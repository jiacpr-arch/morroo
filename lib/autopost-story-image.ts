import sharp from "sharp";

/**
 * Compose a 9:16 (1080×1920) Story image from a square cover.
 *
 * Square cover (1000×1000) is centered over a darkened, blurred copy of the
 * same cover so the top/bottom 460px of the canvas don't read as empty bars.
 * FB Stories + IG Stories share this asset; both accept JPEG ≤ 4 MB. q=90
 * keeps typography crisp while staying well under the size limit.
 */
export async function composeStoryImage(coverBuffer: Buffer): Promise<Buffer> {
  const bg = await sharp(coverBuffer)
    .resize(1080, 1920, { fit: "cover" })
    .blur(40)
    .modulate({ brightness: 0.7 })
    .toBuffer();
  const square = await sharp(coverBuffer)
    .resize(1000, 1000, { fit: "cover" })
    .toBuffer();
  return sharp(bg)
    .composite([{ input: square, gravity: "center" }])
    .flatten({ background: "#ffffff" })
    .jpeg({ quality: 90 })
    .toBuffer();
}
