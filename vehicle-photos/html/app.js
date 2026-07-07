/**
 * Processa screenshot: redimensiona 16:9, comprime PNG < 300KB
 */
const canvas = document.getElementById("canvas");
const ctx = canvas.getContext("2d");

function compressToTarget(canvas, maxKB, qualityStart) {
	return new Promise((resolve) => {
		let quality = qualityStart || 0.92;

		const tryExport = () => {
			const dataUrl = canvas.toDataURL("image/png", quality);
			const sizeKB = Math.ceil((dataUrl.length * 3) / 4 / 1024);

			if (sizeKB <= maxKB || quality <= 0.4) {
				resolve(dataUrl);
				return;
			}

			quality -= 0.08;
			tryExport();
		};

		tryExport();
	});
}

window.addEventListener("message", async (event) => {
	const { action, image, width, height, maxKB, quality } = event.data || {};

	if (action !== "process") return;

	const img = new Image();
	img.onload = async () => {
		canvas.width = width || 800;
		canvas.height = height || 450;

		// Fundo cinza escuro (caso bordas apareçam)
		ctx.fillStyle = "#1a1a1e";
		ctx.fillRect(0, 0, canvas.width, canvas.height);

		// Crop central 16:9 da imagem original
		const targetRatio = canvas.width / canvas.height;
		const srcRatio = img.width / img.height;

		let sx = 0, sy = 0, sw = img.width, sh = img.height;

		if (srcRatio > targetRatio) {
			sw = img.height * targetRatio;
			sx = (img.width - sw) / 2;
		} else {
			sh = img.width / targetRatio;
			sy = (img.height - sh) / 2;
		}

		ctx.drawImage(img, sx, sy, sw, sh, 0, 0, canvas.width, canvas.height);

		const result = await compressToTarget(canvas, maxKB || 300, quality || 0.88);

		fetch(`https://vehicle-photos/processed`, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ data: result })
		});
	};

	img.onerror = () => {
		fetch(`https://vehicle-photos/processed`, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ error: true })
		});
	};

	img.src = image;
});
