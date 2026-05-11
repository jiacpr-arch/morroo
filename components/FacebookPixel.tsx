import Script from "next/script";
import { FB_PIXEL_ID } from "@/lib/facebook-pixel";

/**
 * Loads the Facebook Pixel script and fires PageView. Renders `null` when
 * `NEXT_PUBLIC_FACEBOOK_PIXEL_ID` is unset so dev / preview environments
 * don't ship an empty pixel.
 *
 * Mirrored server-side by `lib/facebook-capi.ts` for the conversion events
 * — PageView is browser-only since it's high-volume and unattributed.
 */
export default function FacebookPixel() {
  if (!FB_PIXEL_ID) return null;

  const init = `
    !function(f,b,e,v,n,t,s)
    {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
    n.callMethod.apply(n,arguments):n.queue.push(arguments)};
    if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
    n.queue=[];t=b.createElement(e);t.async=!0;
    t.src=v;s=b.getElementsByTagName(e)[0];
    s.parentNode.insertBefore(t,s)}(window, document,'script',
    'https://connect.facebook.net/en_US/fbevents.js');
    fbq('init', '${FB_PIXEL_ID}');
    fbq('track', 'PageView');
  `;

  return (
    <>
      <Script id="fb-pixel-init" strategy="afterInteractive">
        {init}
      </Script>
      <noscript>
        <img
          height="1"
          width="1"
          style={{ display: "none" }}
          alt=""
          src={`https://www.facebook.com/tr?id=${FB_PIXEL_ID}&ev=PageView&noscript=1`}
        />
      </noscript>
    </>
  );
}
