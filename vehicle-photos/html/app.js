const canvas = document.getElementById("canvas");
const ctx = canvas.getContext("2d");

function toBase64(img, width, height, maxKB) {
	canvas.width = width;
	canvas.height = height;

	ctx.fillStyle = "#1a1a1e";
	ctx.fillRect(0, 0, width, height);

	const targetRatio = width / height;
	const srcRatio = img.width / img.height;
	let sx = 0, sy = 0, sw = img.width, sh = img.height;

	if (srcRatio > targetRatio) {
		sw = img.height * targetRatio;
		sx = (img.width - sw) / 2;
	} else {
		sh = img.width / targetRatio;
		sy = (img.height - sh) / 2;
	}

	ctx.drawImage(img, sx, sy, sw, sh, 0, 0, width, height);

	let data = canvas.toDataURL("image/png");
	const sizeKB = Math.ceil((data.length * 3) / 4 / 1024);

	if (sizeKB > maxKB) {
		data = canvas.toDataURL("image/jpeg", 0.85);
	}

	return data.replace(/^data:image\/\w+;base64,/, "");
}

function send(ok, image) {
	fetch("https://vehicle-photos/photoReady", {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify({ ok: ok, image: image || "" })
	});
}

window.addEventListener("message", (event) => {
	const data = event.data || {};
	if (data.action !== "process") return;

	const img = new Image();
	img.onload = () => {
		try {
			const result = toBase64(img, data.width || 800, data.height || 450, data.maxKB || 300);
			send(true, result);
		} catch (e) {
			send(false);
		}
	};
	img.onerror = () => send(false);

	const src = data.image || "";
	img.src = src.startsWith("data:") ? src : "data:image/png;base64," + src;
});
