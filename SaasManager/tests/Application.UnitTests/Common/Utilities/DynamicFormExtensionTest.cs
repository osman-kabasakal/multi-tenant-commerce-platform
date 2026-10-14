using System.ComponentModel.DataAnnotations;
using System.Text.Json;
using Core.Utilities;
using FluentAssertions;
using FluentValidation;
using NUnit.Framework;
using SaasManager.Application.Common.Utilities;
using SaasManager.Application.IdentityManagement.Commands.Registration;

namespace SaasManager.Application.UnitTests.Common.Utilities;

public class DynamicFormExtensionTest
{
    #region Test Models
        private class TestFormModel
        {
            [DynamicFormFieldName("text")]
            [Required(ErrorMessage = "Text is required")]
            [StringLength(10, MinimumLength = 3)]
            public string? Text { get; set; }

            // [DynamicFormFieldName("number")]
            [System.ComponentModel.DataAnnotations.Range(1, 100)]
            public int Number { get; set; }

            [DynamicFormFieldName("email")]
            [Required]
            [DataType(DataType.EmailAddress)]
            [RegularExpression(@"^[^@\s]+@[^@\s]+\.[^@\s]+$")]
            public string? Email { get; set; }

            [DynamicFormFieldName("date")]
            [DataType(DataType.Date)]
            public DateTime? Date { get; set; }

            [DynamicFormFieldName("type")]
            public TestEnum Type { get; set; }
        }

        private enum TestEnum
        {
            Type1,
            Type2,
            Type3
        }
        #endregion

        #region Model Conversion Tests
        [Test]
        public void ToDynamicFormModel_WithValidData_ShouldConvertSuccessfully()
        {
            // Arrange
            var data = new Dictionary<string, object>
            {
                ["text"] = "Test",
                ["Number"] = 50,
                ["email"] = "test@example.com",
                ["date"] = "2024-01-01",
                ["type"] = "Type1"
            };

            // Act
            var model = data.ToDynamicFormModel<TestFormModel>();

            // Assert
            model.Should().NotBeNull();
            model.Text.Should().Be("Test");
            model.Number.Should().Be(50);
            model.Email.Should().Be("test@example.com");
            model.Date.Should().Be(new DateTime(2024, 1, 1));
            model.Type.Should().Be(TestEnum.Type1);
        }

        [Test]
        public void ToDynamicFormModel_WithJsonElementData_ShouldConvertSuccessfully()
        {
            // Arrange
            var jsonData = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(
                """
                {
                    "text": "Test",
                    "Number": 50,
                    "email": "test@example.com",
                    "date": "2024-01-01",
                    "type": "Type1"
                }
                """
            );

            var data = jsonData!.ToDictionary(x => x.Key, x => (object)x.Value);

            // Act
            var model = data.ToDynamicFormModel<TestFormModel>();

            // Assert
            model.Should().NotBeNull();
            model.Text.Should().Be("Test");
            model.Number.Should().Be(50);
            model.Email.Should().Be("test@example.com");
            model.Date.Should().Be(new DateTime(2024, 1, 1));
            model.Type.Should().Be(TestEnum.Type1);
        }

        [Test]
        public void ToDynamicFormModel_WithMissingOptionalFields_ShouldConvertSuccessfully()
        {
            // Arrange
            var data = new Dictionary<string, object>
            {
                ["text"] = "Test",
                ["email"] = "test@example.com"
            };

            // Act
            var model = data.ToDynamicFormModel<TestFormModel>();

            // Assert
            model.Should().NotBeNull();
            model.Text.Should().Be("Test");
            model.Email.Should().Be("test@example.com");
            model.Date.Should().BeNull();
            model.Number.Should().Be(0); // Default value
            model.Type.Should().Be(TestEnum.Type1); // Default enum value
        }

        [Test]
        public void ToDynamicFormModel_WithInvalidTypeData_ShouldThrowException()
        {
            // Arrange
            var data = new Dictionary<string, object>
            {
                ["Number"] = "not-a-number"
            };

            // Act & Assert
            Assert.Throws<ArgumentException>(() => data.ToDynamicFormModel<TestFormModel>());
        }
        #endregion

        #region Form Definition Tests
        [Test]
        public void ToRegistrationStepExpectedParameters_ShouldCreateCorrectDefinition()
        {
            // Act
            var definition = DynamicFormExtensions.ToDynamicFormParameters<TestFormModel>();

            // Assert
            definition.Should().ContainKey("text");
            definition["text"].Type.Should().Be("text");
            definition["text"].Required.Should().BeTrue();
            definition["text"].Validations.Should().ContainKey("minLength");
            definition["text"].Validations.Should().ContainKey("maxLength");

            definition.Should().ContainKey("email");
            definition["email"].Type.Should().Be("email");
            definition["email"].Required.Should().BeTrue();

            definition.Should().ContainKey("Number");
            definition["Number"].Type.Should().Be("number");
            definition["Number"].Validations.Should().ContainKey("min");
            definition["Number"].Validations.Should().ContainKey("max");

            definition.Should().ContainKey("date");
            definition["date"].Type.Should().Be("date");

            definition.Should().ContainKey("type");
            definition["type"].Type.Should().Be("select");
        }
        #endregion

        #region Validation Tests
        [Test]
        public void Validate_WithValidModel_ShouldPass()
        {
            // Arrange
            var model = new TestFormModel
            {
                Text = "Valid",
                Number = 50,
                Email = "test@example.com",
                Date = DateTime.Today,
                Type = TestEnum.Type1
            };
            var validator = new DynamicFormValidator<TestFormModel>();

            // Act
            var result = validator.Validate(model);

            // Assert
            result.IsValid.Should().BeTrue();
            result.Errors.Should().BeEmpty();
        }

        [Test]
        public void Validate_WithInvalidModel_ShouldFail()
        {
            // Arrange
            var model = new TestFormModel
            {
                Text = "To", // Too short
                Number = 101, // Out of range
                Email = "not-an-email",
                Type = TestEnum.Type1
            };
            var validator = new DynamicFormValidator<TestFormModel>();

            // Act
            var result = validator.Validate(model);

            // Assert
            result.IsValid.Should().BeFalse();
            result.Errors.Should().HaveCountGreaterThan(0);
            result.Errors.Should().Contain(e => e.PropertyName == "text");
            result.Errors.Should().Contain(e => e.PropertyName == "Number");
            result.Errors.Should().Contain(e => e.PropertyName == "email");
        }

        [Theory]
        [TestCase("", "test@example.com", 50)] // Empty text
        [TestCase("Test", "", 50)] // Empty email
        [TestCase("Test", "test@example.com", 0)] // Invalid number
        public void Validate_WithVariousInvalidInputs_ShouldFail(string text, string email, int number)
        {
            // Arrange
            var model = new TestFormModel
            {
                Text = text,
                Email = email,
                Number = number
            };
            var validator = new DynamicFormValidator<TestFormModel>();

            // Act
            var result = validator.Validate(model);

            // Assert
            result.IsValid.Should().BeFalse();
        }
        #endregion

        #region Custom Validation Tests
        private class CardFormModel
        {
            [DynamicFormFieldName("cardNumber")]
            [Required]
            [RegularExpression(@"^\d{16}$")]
            public string? CardNumber { get; set; }
        }

        private class CardFormValidator : DynamicFormValidator<CardFormModel>
        {
            public CardFormValidator() : base()
            {
                RuleFor(x => x.CardNumber)
                    .Must(BeValidLuhn)
                    .WithMessage("Invalid card number");
            }

            private bool BeValidLuhn(string? number)
            {
                if (string.IsNullOrEmpty(number)) return false;
                return true; // Simplified for test
            }
        }

        [Test]
        public void Validate_WithCustomValidator_ShouldApplyCustomRules()
        {
            // Arrange
            var model = new CardFormModel
            {
                CardNumber = "1234567890123456"
            };
            var validator = new CardFormValidator();

            // Act
            var result = validator.Validate(model);

            // Assert
            result.IsValid.Should().BeTrue();
        }
        #endregion

        #region Edge Cases
        [Test]
        public void ToDynamicFormModel_WithNullData_ShouldNotThrowException()
        {
            // Arrange
            var data = new Dictionary<string, object>();

            // Act & Assert
            Assert.DoesNotThrow(() => data.ToDynamicFormModel<TestFormModel>());
        }

        [Test]
        public void ToDynamicFormModel_WithUnknownFields_ShouldIgnoreThem()
        {
            // Arrange
            var data = new Dictionary<string, object>
            {
                ["text"] = "Test",
                ["unknown_field"] = "value"
            };

            // Act
            var model = data.ToDynamicFormModel<TestFormModel>();

            // Assert
            model.Should().NotBeNull();
            model.Text.Should().Be("Test");
        }
        #endregion
}
