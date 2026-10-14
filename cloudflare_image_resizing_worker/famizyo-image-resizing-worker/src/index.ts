/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `npm run dev` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `npm run deploy` to publish your worker
 *
 * Bind resources to your worker in `wrangler.jsonc`. After adding bindings, a type definition for the
 * `Env` object can be regenerated with `npm run cf-typegen`.
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */
type imageFitType= "scale-down" | "contain" | "cover" | "crop" | "pad" | "squeeze";
type imageQualityType = number |"low" | "medium-low" | "medium-high" | "high";
type ImageFormatType = | "avif"
| "webp"
| "json"
| "jpeg"
| "png"
| "baseline-jpeg"
| "png-force"
| "svg";
interface ImageResizingOptions {
	fit?:String|null;

width?:String|null;

height?:String|null;

quality?:String|null;

format?:String|null;

}
function parseQuality(qualityParam: string | null): imageQualityType | undefined {
	if (!qualityParam) return undefined;
	
	// Önce string değerleri kontrol et
	if (["low", "medium-low", "medium-high", "high"].includes(qualityParam)) {
	  return qualityParam as "low" | "medium-low" | "medium-high" | "high";
	}
	
	// Sayısal değer için kontrol et
	const numValue = Number(qualityParam);
	if (!isNaN(numValue)) {
	  return numValue;
	}
	
	// Geçersiz değer
	return undefined;
  }
  function parseImageFormat(formatParam: string | null): ImageFormatType | undefined {
	if (!formatParam) return undefined;
	
	// Girdiyi küçük harfe çevir, böylece büyük/küçük harf farklılıklarını ele alabilirsin
	const normalizedFormat = formatParam.toLowerCase();
	
	// Geçerli bir format mu kontrol et
	const validFormats: ImageFormatType[] = [
	  "avif",
	  "webp",
	  "json",
	  "jpeg",
	  "png",
	  "baseline-jpeg",
	  "png-force",
	  "svg"
	];
	
	if (validFormats.includes(normalizedFormat as ImageFormatType)) {
	  return normalizedFormat as ImageFormatType;
	}
	
	// Geçersiz değer
	return undefined;
  }
  
export default {
	async fetch(request, env, ctx): Promise<Response> {
		// Parse request URL to get access to query string
		let url = new URL(request.url)

		// Cloudflare-specific options are in the cf object.
		let options:RequestInit<RequestInitCfProperties> = { cf: { image: {} } }
	
		// Copy parameters from query string to request options.
		// You can implement various different parameters here.
		if (url.searchParams.has("fit")) options.cf!.image!.fit = (url.searchParams.get("fit") as imageFitType)??"scale-down";
		if (url.searchParams.has("width")) options!.cf!.image!.width = parseInt(url.searchParams.get("width")??"680")
		if (url.searchParams.has("height")) options!.cf!.image!.height = url.searchParams.get("height") != null ? parseInt(url.searchParams.get("height")!): undefined
		if (url.searchParams.has("quality")) options!.cf!.image!.quality = parseQuality(url.searchParams.get("quality"));
		if (url.searchParams.has("format")) options!.cf!.image!.format = parseImageFormat(url.searchParams.get("format"));
	
		// Get URL of the original (full size) image to resize.
		// You could adjust the URL here, e.g., prefix it with a fixed address of your server,
		// so that user-visible URLs are shorter and cleaner.
		const imageURL = url.searchParams.get("image")
		if (!imageURL) return new Response('Missing "image" value', { status: 400 })
	
		try {
		  // TODO: Customize validation logic
		  const { hostname, pathname } = new URL(imageURL)
	
		  // Optionally, only allow URLs with JPEG, PNG, GIF, or WebP file extensions
		  // @see https://developers.cloudflare.com/images/url-format#supported-formats-and-limitations
		  if (!/\.(jpe?g|png|gif|webp)$/i.test(pathname)) {
			return new Response('Disallowed file extension', { status: 400 })
		  }
	
		  // Demo: Only accept "example.com" images
		  if (!hostname.endsWith('commerce.test')) {
			return new Response('Must use "commerce.test" source images', { status: 403 })
		  }
		} catch (err) {
		  return new Response('Invalid "image" value', { status: 400 })
		}
	
		// Build a request that passes through request headers
		const imageRequest = new Request(imageURL, {
		  headers: request.headers,
		})
	
		// Returning fetch() with resizing options will pass through response with the resized image.
		return fetch(imageRequest, options)
	},
} satisfies ExportedHandler<Env>;
