

# SaasManager Release modunda çalıştırma scripti

echo "SaasManager uygulamasını Release modunda derleme ve çalıştırma başlatılıyor..."

# Çalışma dizinini ayarla
#cd "$(dirname "$0")"

# .NET uygulamasını Release modunda derle
echo "Backend derleniyor..."
dotnet restore "src/Web/Web.csproj"
dotnet build "src/Web/Web.csproj" -c Release -o ./app/build

# Angular uygulamasını production modunda derle
echo "Frontend derleniyor..."
cd src/Web/ClientApp || exit
npm install
npm run build -- --configuration production
cd ../../.. || exit

# Uygulamayı publish et
echo "Uygulama publish ediliyor..."
dotnet publish "./src/Web/Web.csproj" -c Release -o app/publish /p:UseAppHost=false

#Statik içerikleri publish dizinine kopyala
echo "Statik içerikler kopyalanıyor..."
mkdir -p ./app/publish/wwwroot
cp -R ./src/Web/ClientApp/dist/browser/. ./app/publish/wwwroot/

# Uygulamayı çalıştır
echo "Uygulama çalıştırılıyor..."
export ASPNETCORE_ENVIRONMENT=Production
cd app/publish
dotnet SaasManager.Web.dll