<script lang="ts">
    import { onMount } from "svelte";
    import Cropper from "svelte-easy-crop";
    let frame: string = "";

    onMount(() => {
        frame = data.campaign?.frame!
    })

    export let data;

    let files: FileList | undefined;
    let cnv: HTMLCanvasElement;
    let frameElement: HTMLImageElement;

    let afbeelding = "";
    let gegenereerd = false;

    let teDownloaden = "";

    let crop = { x: 0, y: 0 };

    let uploadButton: HTMLInputElement | undefined;

    async function readFile(file: File) {
        return new Promise((resolve, reject) => {
            var fr = new FileReader();

            fr.onload = () => {
                resolve(fr.result);
            };
            fr.onerror = reject;
            fr.readAsDataURL(file);
        });
    }

    async function onFileSelected(e: any) {
        let imageFile = files![0];
        afbeelding = (await readFile(imageFile)) as string;
    }

    async function gecropt(pos: {
        detail: {
            pixels: { x: number; y: number; width: number; height: number };
        };
    }): Promise<void> {
        let pf = new Image();
        pf.src = afbeelding;

        let ctx = cnv.getContext("2d")!;

        let x = pos.detail.pixels.x;
        let y = pos.detail.pixels.y;
        let width = pos.detail.pixels.width;
        let height = pos.detail.pixels.height;

        gegenereerd = true;

        ctx.clearRect(0, 0, 1500, 1500);
        ctx.drawImage(pf, x, y, width, height, 0, 0, 1500, 1500);
        ctx.drawImage(frameElement, 0, 0, 1500, 1500);

        teDownloaden = cnv.toDataURL();
    }
</script>

<div
    class="p-8 bg-indigo-100 flex flex-col gap-4 items-center align-center size-full h-screen w-screen overflow-x-hidden"
>
    <img src={frame} class="hidden" alt="frame" bind:this={frameElement} />
    <h1 class="text-3xl font-bold text-center">
        {data.campaign.title}
    </h1>
    <div class="flex flex-row gap-4">
        <button
            class="bg-indigo-500 px-4 py-2 text-white rounded-md"
            on:click={() => {
                uploadButton?.click();
            }}
        >
            {#if files && files.length > 0}
                Kies een andere foto...
            {:else}
                Kies een bestand...
            {/if}
        </button>
        <input
            class="hidden"
            type="file"
            accept="image/*"
            bind:files
            bind:this={uploadButton}
            on:change={(e) => onFileSelected(e)}
        />

        {#if gegenereerd}
            <a
                href={teDownloaden}
                download={`${data.campaign?.slug}.png`}
                class="rounded-md bg-white px-4 py-2 shrink text-center"
            >
                Download!
            </a>
        {/if}
    </div>

    <div
        class="flex flex-col lg:flex-row gap-4 w-full max-h-full items-center justify-stretch grow"
    >
        {#if afbeelding != ""}
            <div class="relative w-full lg:w-1/2 aspect-square">
                <Cropper
                    image={afbeelding}
                    aspect={1}
                    minZoom={1}
                    bind:crop
                    cropShape="round"
                    on:cropcomplete={gecropt}
                />
            </div>

            <div class="flex flex-col gap-2 items-center">
                <h3>een preview:</h3>
                <div
                    class="object-contain basis-1/3 lg:basis-inherit lg:size-1/2 shrink"
                >
                    <canvas
                        width="1500"
                        height="1500"
                        id="cnv"
                        bind:this={cnv}
                        class="max-w-full max-h-full"
                    ></canvas>
                </div>
            </div>
        {/if}
    </div>
</div>
