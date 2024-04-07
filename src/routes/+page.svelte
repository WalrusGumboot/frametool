<script lang="ts">
    import frame from "../frame.png";
    import Cropper from "svelte-easy-crop";

    let files: FileList;
    let cnv: HTMLCanvasElement;
    let frameElement: HTMLImageElement;

    let afbeelding = "";
    let gegenereerd = false;

    let teDownloaden = "";

    let crop = {x: 0, y: 0};

    async function readFile(file: File){
        return new Promise((resolve, reject) => {
            var fr = new FileReader();  

            fr.onload = () => {
                resolve(fr.result)
            };
            fr.onerror = reject;
            fr.readAsDataURL(file);
        });
    }

    async function onFileSelected(e: any) {
  	    let imageFile = files[0];
		afbeelding = await readFile(imageFile) as string;
	}

    async function gecropt(pos: {
        detail: {
            pixels: { x: number; y: number; width: number; height: number };
        };
    }): Promise<void> {
        let pf = new Image()
        pf.src = afbeelding;

        let ctx = cnv.getContext("2d")!;

        let x = pos.detail.pixels.x;
        let y = pos.detail.pixels.y;
        let width = pos.detail.pixels.width;
        let height = pos.detail.pixels.height;

        gegenereerd = true;
        
        ctx.clearRect(0, 0, 400, 400);
        ctx.drawImage(pf, x, y, width, height, 0, 0, 400, 400);
        ctx.drawImage(frameElement, 0, 0, 400, 400);

        teDownloaden = cnv.toDataURL();
    }
</script>

<div
    class="p-6 bg-red-100 flex flex-col gap-4 items-center align-center size-full min-h-screen"
>
    <img src={frame} class="hidden" alt="frame" bind:this={frameElement} />
    <h1 class="text-3xl font-bold">Pixels epische frame tool!</h1>
    <input
        class="border border-black bg-white px-4 py-2"
        type="file"
        accept="image/*"
        bind:files
        on:change={(e) => onFileSelected(e)}
    />

    <div class="flex flex-col lg:flex-row gap-4 w-full items-center justify-stretch">
        {#if afbeelding != ""}
            <div class="relative w-1/3 aspect-square">
                <Cropper
                    image={afbeelding}
                    aspect={1}
                    minZoom={1}
                    bind:crop
                    cropShape="round"
                    on:cropcomplete={gecropt}
                />
            </div>
        {/if}
    
        <canvas width="400" height="400" id="cnv" bind:this={cnv} class="size-1/3 aspect-square"></canvas>
        {#if gegenereerd}
            <a
                href={teDownloaden}
                download="pixel-profielfoto.png"
                class="border border-black bg-white px-4 py-2 grow text-center"
            >
                Download je profielfoto hier!
            </a>
        {/if}
    </div>
</div>
