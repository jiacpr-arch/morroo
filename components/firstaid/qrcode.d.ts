// qrcode@1.x ships no TypeScript declarations — minimal typing for the one API
// surface we use (LineGateCard / LinePopup QR generation).
declare module "qrcode" {
  export function toDataURL(
    text: string,
    options?: { margin?: number; width?: number },
  ): Promise<string>;
  const QRCode: { toDataURL: typeof toDataURL };
  export default QRCode;
}
