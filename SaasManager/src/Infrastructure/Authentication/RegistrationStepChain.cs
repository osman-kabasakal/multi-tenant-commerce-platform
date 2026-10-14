// namespace SaasManager.Infrastructure.Authentication;
//
// public class RegistrationStepChain
// {
//     private readonly IEnumerable<IRegistrationStep> _steps;
//
//     public RegistrationStepChain(IEnumerable<IRegistrationStep> steps)
//     {
//         _steps = steps;
//     }
//
//     public async Task<IRegistrationStep> DetermineCurrentStepAsync(
//         GuestRegistration guest,
//         CancellationToken cancellationToken)
//     {
//         foreach (var step in _steps)
//         {
//             var validationResult = await step.ValidateAsync(guest, new(), cancellationToken);
//             if (!validationResult.IsValid)
//                 return step;
//         }
//
//         return _steps.Last();
//     }
//
//     public IRegistrationStep? GetStepByKey(string stepKey)
//     {
//         return _steps.FirstOrDefault(s => s.StepKey == stepKey);
//     }
//
//     public IRegistrationStep GetInitialStep()
//     {
//         return _steps.First();
//     }
//
//     public IRegistrationStep? GetNextStep(string currentStepKey)
//     {
//         var currentIndex = _steps.ToList()
//             .FindIndex(s => s.StepKey == currentStepKey);
//
//         if (currentIndex < 0 || currentIndex >= _steps.Count() - 1)
//             return null;
//
//         return _steps.ElementAt(currentIndex + 1);
//     }
// }
