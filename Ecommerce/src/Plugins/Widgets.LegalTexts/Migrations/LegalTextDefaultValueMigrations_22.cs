using Grand.Data;
using Grand.Infrastructure.Migrations;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Widgets.LegalTexts.Models;
using Widgets.LegalTexts.Services;

namespace Widgets.LegalTexts.Migrations;

public class LegalTextDefaultValueMigrations_22: IMigration
{
    public int Priority => 0;

    public DbVersion Version => new(2, 2);

    public Guid Identity => new("bc20e4ec-0ed6-4726-8542-54a80f0590a7");

    public string Name => "LegalTextDefaultValueMigrations_22_1";

    private string distantSalesContractContent = @"
<!DOCTYPE html>
<html lang=""tr"">
<head>
    <meta charset=""UTF-8"">
    <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">
    <title>Mesafeli Satış Sözleşmesi</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
            background-color: #f9f9f9;
        }

        .container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #2c3e50;
            text-align: center;
        }

        h2 {
            font-size: 20px;
            margin: 25px 0 15px 0;
            color: #34495e;
        }

        .section {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .info-block {
            margin: 10px 0;
        }

        .info-block strong {
            display: inline-block;
            min-width: 150px;
            margin-right: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f5f5f5;
        }

        @media (max-width: 768px) {
            body {
                padding: 10px;
            }

            .container {
                padding: 15px;
            }

            h1 {
                font-size: 20px;
            }

            h2 {
                font-size: 18px;
            }

            .info-block strong {
                display: block;
                margin-bottom: 5px;
            }

            table {
                font-size: 14px;
            }

            th, td {
                padding: 8px;
            }
        }
    </style>
</head>
<body>
    <div class=""container"">
        <h1>Mesafeli Satış Sözleşmesi</h1>
        
        <div class=""section"">
            <h2>1. TARAFLAR</h2>
          	<p>İşbu Sözleşme aşağıdaki taraflar arasında aşağıda belirtilen hüküm ve şartlar çerçevesinde imzalanmıştır.</p>
            <div class=""info-block"">
                <p><strong>SATICI:</strong></p>
                <p>Ünvan: {{Store.CompanyName}}</p>
                <p>Adres: {{Store.CompanyAddress}}</p>
                <p>Telefon: {{Store.CompanyPhoneNumber}}</p>
                <p>E-posta: {{Store.CompanyEmail}}</p>
            </div>
            <div class=""info-block"">
                <p><strong>ALICI:</strong></p>
                <p>Ad Soyad: {{Customer.FullName}}</p>
                <p>Adres: {{Customer.StreetAddress}}</p>
                <p>Telefon: {{Customer.Phone}}</p>
                <p>E-posta: {{Customer.Email}}</p>
            </div>
          <p>İş bu sözleşmeyi kabul etmekle ALICI, sözleşme konusu siparişi onayladığı takdirde sipariş konusu bedeli ve varsa kargo ücreti, vergi gibi belirtilen ek ücretleri ödeme yükümlülüğü altına gireceğini ve bu konuda bilgilendirildiğini peşinen kabul eder.</p>
        </div>

        <div class=""section"">
            <h2>2. TESLİMAT BİLGİLERİ</h2>
            <div class=""info-block"">
                <p><strong>Teslimat Adresi:</strong> {{ShippingAdress.Address}}</p>
                <p><strong>Teslim Edilecek Kişi:</strong> {{ShippingAdress.FullName}}</p>
                <p><strong>Telefon:</strong> {{ShippingAdress.Phone}}</p>
            </div>
        </div>

        <div class=""section"">
            <h2>3. ÜRÜN BİLGİLERİ VE TOPLAM BEDEL</h2>
            <table>
                <thead>
                    <tr>
                        <th>Ürün</th>
                        <th>Adet</th>
                        <th>Birim Fiyat</th>
                        <th>Toplam</th>
                    </tr>
                </thead>
                <tbody>
                    {% for item in ShoppingCart.Items %}
                    <tr>
                        <td>{{item.ProductName}}</td>
                        <td>{{item.Quantity}}</td>
                        <td>{{item.UnitPrice}}</td>
                        <td>{{item.SubTotal}}</td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
            <div class=""info-block"">
                <p><strong>Ara Toplam:</strong> {{OrderTotals.SubTotal}}</p>
                <p><strong>KDV:</strong> {{OrderTotals.Tax}}</p>
                <p><strong>Kargo Ücreti:</strong> {{OrderTotals.Shipping}}</p>
                <p><strong>Toplam Tutar:</strong> {{OrderTotals.OrderTotal}}</p>
            </div>
        </div>

        <div class=""section"">
            <h2>4. GENEL HÜKÜMLER</h2>
            <p>4.1. İşbu sözleşme, ALICI'nın, SATICI'ya ait internet sitesi üzerinden elektronik ortamda siparişini verdiği yukarıda nitelikleri ve satış fiyatı belirtilen ürünün satışı ve teslimi ile ilgili olarak 6502 sayılı Tüketicinin Korunması Hakkında Kanun ve Mesafeli Sözleşmeler Yönetmeliği hükümleri gereğince tarafların hak ve yükümlülüklerini düzenler.</p>
        </div>

        <div class=""section"">
            <h2>5. CAYMA HAKKI</h2>
            <p>ALICI, mesafeli sözleşmenin mal satışına ilişkin olması durumunda, ürünün kendisine veya gösterdiği adresteki kişi/kuruluşa teslim tarihinden itibaren 14 gün içerisinde, SATICI'ya bildirmek şartıyla hiçbir gerekçe göstermeksizin malı reddederek sözleşmeden cayma hakkını kullanabilir.</p>
        </div>

        <div class=""section"">
            <h2>6. YETKİLİ MAHKEME</h2>
            <p>İşbu sözleşmeden doğan uyuşmazlıklarda şikayet ve itirazlar, tüketicinin yerleşim yerinin bulunduğu veya tüketici işleminin yapıldığı yerdeki tüketici sorunları hakem heyetine veya tüketici mahkemesine yapılacaktır.</p>
        </div>
    </div>
</body>
</html>
";

    private string preInfoFormContent = @"
<!DOCTYPE html>
<html lang=""tr"">
<head>
    <meta charset=""UTF-8"">
    <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">
    <title>Ön Bilgilendirme Formu</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
            background-color: #f9f9f9;
        }

        .container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #2c3e50;
            text-align: center;
        }

        h2 {
            font-size: 20px;
            margin: 25px 0 15px 0;
            color: #34495e;
        }

        .section {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .info-block {
            margin: 10px 0;
        }

        .info-block strong {
            display: inline-block;
            min-width: 150px;
            margin-right: 10px;
        }

        p {
            margin: 10px 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f5f5f5;
        }

        .sub-section {
            margin-left: 20px;
            margin-top: 10px;
        }

        .signature-section {
            margin-top: 40px;
            display: flex;
            justify-content: space-between;
        }

        .signature-block {
            margin-top: 20px;
        }

        @media (max-width: 768px) {
            body {
                padding: 10px;
            }

            .container {
                padding: 15px;
            }

            h1 {
                font-size: 20px;
            }

            h2 {
                font-size: 18px;
            }

            .info-block strong {
                display: block;
                margin-bottom: 5px;
            }

            .signature-section {
                flex-direction: column;
            }

            .signature-block {
                margin-top: 20px;
            }
        }
    </style>
</head>
<body>
    <div class=""container"">
        <h1>ÖN BİLGİLENDİRME FORMU</h1>
        
        <div class=""section"">
            <h2>1. KONU</h2>
            <p>İşbu Satış Sözleşmesi Ön Bilgi Formu'nun konusu, SATICI'nın, SİPARİŞ VEREN/ALICI'ya satışını yaptığı, aşağıda nitelikleri ve satış fiyatı belirtilen ürün/ürünlerin satışı ve teslimi ile ilgili olarak 6502 sayılı Tüketicilerin Korunması Hakkındaki Kanun - Mesafeli Sözleşmeler Yönetmeliği (RG:27.11.2014/29188) hükümleri gereğince tarafların hak ve yükümlülüklerini kapsamaktadır.</p>
        </div>

        <div class=""section"">
            <h2>2. SATICI BİLGİLERİ</h2>
            <div class=""info-block"">
                <p><strong>Ünvanı:</strong> {{Store.CompanyName}}</p>
                <p><strong>Adres:</strong> {{Store.CompanyAddress}}</p>
                <p><strong>Telefon:</strong> {{Store.CompanyPhoneNumber}}</p>
                <p><strong>E-posta:</strong> {{Store.CompanyEmail}}</p>
            </div>
        </div>

        <div class=""section"">
            <h2>3. ALICI BİLGİLERİ</h2>
            <div class=""info-block"">
                <p><strong>Ad Soyad:</strong> {{Customer.FullName}}</p>
                <p><strong>Teslimat Adresi:</strong> {{ShippingAdress.Address}}</p>
                <p><strong>Telefon:</strong> {{Customer.Phone}}</p>
                <p><strong>E-posta:</strong> {{Customer.Email}}</p>
            </div>
        </div>

        <div class=""section"">
            <h2>4. SÖZLEŞME KONUSU ÜRÜN/ÜRÜNLER BİLGİLERİ</h2>
            <table>
                <thead>
                    <tr>
                        <th>Ürün</th>
                        <th>Adet</th>
                        <th>Birim Fiyat</th>
                        <th>Toplam</th>
                    </tr>
                </thead>
                <tbody>
                    {% for item in ShoppingCart.Items %}
                    <tr>
                        <td>{{item.ProductName}}</td>
                        <td>{{item.Quantity}}</td>
                        <td>{{item.UnitPrice}}</td>
                        <td>{{item.SubTotal}}</td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
            <div class=""info-block"">
                <p><strong>Ara Toplam:</strong> {{OrderTotals.SubTotal}}</p>
                <p><strong>KDV:</strong> {{OrderTotals.Tax}}</p>
                <p><strong>Kargo Ücreti:</strong> {{OrderTotals.Shipping}}</p>
                <p><strong>Toplam Tutar:</strong> {{OrderTotals.OrderTotal}}</p>
            </div>
        </div>

        <div class=""section"">
            <h2>5. CAYMA HAKKI</h2>
            <p>ALICI; mal satışına ilişkin mesafeli sözleşmelerde, ürünün kendisine veya gösterdiği adresteki kişi/kuruluşa teslim tarihinden itibaren 14 (on dört) gün içerisinde, SATICI'ya bildirmek şartıyla hiçbir hukuki ve cezai sorumluluk üstlenmeksizin ve hiçbir gerekçe göstermeksizin malı reddederek sözleşmeden cayma hakkını kullanabilir.</p>
        </div>

        <div class=""section"">
            <h2>6. CAYMA HAKKI KULLANILAMAYACAK ÜRÜNLER</h2>
            <p>Aşağıdaki ürünlerde cayma hakkı kullanılamaz:</p>
            <div class=""sub-section"">
                <p>• Fiyatı finansal piyasalardaki dalgalanmalara bağlı olarak değişen ve satıcı veya sağlayıcının kontrolünde olmayan mal veya hizmetler</p>
                <p>• Tüketicinin istekleri veya kişisel ihtiyaçları doğrultusunda hazırlanan mallar</p>
                <p>• Çabuk bozulabilen veya son kullanma tarihi geçebilecek mallar</p>
                <p>• Tesliminden sonra ambalaj, bant, mühür, paket gibi koruyucu unsurları açılmış olan mallardan; iadesi sağlık ve hijyen açısından uygun olmayanlar</p>
            </div>
        </div>

        <div class=""signature-section"">
            <div class=""signature-block"">
                <p><strong>SATICI:</strong></p>
                <p>{{Store.CompanyName}}</p>
            </div>
            <div class=""signature-block"">
                <p><strong>ALICI:</strong></p>
                <p>{{Customer.FullName}}</p>
                <p>Tarih: {{OrderTotals.CreatedDate}}</p>
            </div>
        </div>
    </div>
</body>
</html>
";
    
    

    public bool UpgradeProcess(IDatabaseContext database, IServiceProvider serviceProvider)
    {
        var logger = serviceProvider.GetRequiredService<ILogger<LegalTextDefaultValueMigrations_22>>();
        try
        {
            var legalTextMessageTemplateService = serviceProvider.GetRequiredService<ILegalTextMessageTemplateService>();
            
            var messages = legalTextMessageTemplateService.GetMessageTemplateByCategory("OrderConfirmation").GetAwaiter().GetResult();
            if (messages != null && messages.Count>0)
                return true;
            
            var distantContractModel = new LegalTextMessageTemplateModel {
                Name = "Mesafeli Satış Sözleşmesi",
                Body = distantSalesContractContent,
                Category = "OrderConfirmation",
                Order = 0,
                IsRequired = true,
                IsActive = true,
            };
            legalTextMessageTemplateService.InsertMessageTemplate(distantContractModel.ToEntity()).GetAwaiter().GetResult();
            logger.LogInformation("Distant Sales Contract Legal Text has been added to the message template list.");

            var preInfoFormModel = new LegalTextMessageTemplateModel {
                Name = "Ön Bilgilendirme Formu",
                Body = preInfoFormContent,
                Category = "OrderConfirmation",
                Order = 0,
                IsRequired = true,
                IsActive = true,
            };
            legalTextMessageTemplateService.InsertMessageTemplate(preInfoFormModel.ToEntity()).GetAwaiter().GetResult();

            logger.LogInformation("LegalTExt migrations completed.");
            return true;
        }
        catch (System.Exception ex)
        {
            logger.LogError(ex,"Stale Cache Key Cleaner Task has not been added to the schedule task list.");
            return false;
        }
    }
}