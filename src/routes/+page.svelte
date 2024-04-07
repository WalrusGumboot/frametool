<script lang="ts">
    import frame from "../frame.png";

    let files: FileList;
    let cnv: HTMLCanvasElement;
    let frameElement: HTMLImageElement;

    let gegenereerd = false;

    async function run(): Promise<void> {
        let buf = new Blob([await files[files.length - 1].arrayBuffer()]);
        let pf = await createImageBitmap(buf);
        let ctx = cnv.getContext("2d")!;

        ctx.drawImage(pf, 0, 0, 400, 400);
        ctx.drawImage(frameElement, 0, 0, 400, 400);

        gegenereerd = true;
    }
</script>

<div class="p-6 bg-red-100 flex flex-col gap-4 items-center w-screen h-screen overflow-hidden">
    <img src={frame} class="hidden" alt="frame" bind:this={frameElement}>
    <h1 class="text-3xl font-bold">Pixels epische frame tool!</h1>
    <input class="border border-black bg-white px-4 py-2" type="file" accept="image/*" bind:files on:change={run}>
    <canvas width=400 height=400 id="cnv" bind:this={cnv}></canvas>
    {#if gegenereerd}
        <a href={cnv.toDataURL("image/png")} download="pixel-profielfoto.png" class="border border-black bg-white px-4 py-2">
            Download je profielfoto hier!
        </a>
    {/if}
</div>