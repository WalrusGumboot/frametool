<script lang="ts">
    import { fade } from "svelte/transition";

    let uploadModal = false;

    let slugField = "";
    let titleField = "";
    let frameCandidates: FileList;

    async function uploadNewFrame() {
        const reader = new FileReader();
        reader.onloadend = async () => {
            const resp = await fetch("uploadNewFrame", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    title: titleField,
                    slug: slugField,
                    frame: reader.result,
                }),
            });

            const respBody = await resp.json();

            if (resp.status != 201) {
                alert(respBody.error);
            } else {
                alert(
                    `OK! Je frame is nu te bezichtigen op ${window.location.hostname}/${slugField}`,
                );
            }
        };
        reader.readAsDataURL(frameCandidates[0]);
    }
</script>

{#if uploadModal}
    <div
        transition:fade={{ duration: 100 }}
        class="bg-neutral-900/60 absolute inset-0 flex flex-col items-center justify-center"
        on:click={() => {
            uploadModal = false;
        }}
        role="none"
    >
        <!-- svelte-ignore a11y-click-events-have-key-events -->
        <!-- svelte-ignore a11y-no-noninteractive-element-interactions -->
        <div
            class="bg-white p-8 rounded-md shadow-md min-w-1/2 z-20"
            on:click={(e) => {
                e.stopImmediatePropagation();
            }}
            role="dialog"
            tabindex="-1"
        >
            <h2 class="text-2xl font-bold mb-4">Nieuw frame</h2>
            <div class="flex flex-col gap-3">
                <label for="title" class="text-sm text-gray-800 -mb-2"
                    >Naam van de campagne</label
                >
                <input
                    name="title"
                    required
                    class="bg-indigo-50 rounded-sm px-4 py-2"
                    placeholder="Axiom profielfoto"
                    on:input={(e) => {
                        const original = e.currentTarget.value;
                        slugField = original
                            .replaceAll(/[^a-zA-Z0-9]+/g, "-")
                            .toLowerCase();
                    }}
                />

                <label for="slug" class="text-sm text-gray-800 -mb-2"
                    >Slug</label
                >
                <input
                    name="slug"
                    bind:value={slugField}
                    required
                    class="bg-indigo-50 rounded-sm px-4 py-2"
                    placeholder="Axiom profielfoto"
                />

                <label for="image" class="text-sm text-gray-800 -mb-2"
                    >Afbeelding</label
                >

                <input
                    name="image"
                    type="file"
                    accept="image/png"
                    bind:files={frameCandidates}
                />

                <input
                    type="submit"
                    value="Upload frame"
                    class="rounded-md bg-indigo-500 text-white px-4 py-2 mt-6"
                    on:click={uploadNewFrame}
                />
            </div>
        </div>
    </div>
{/if}

<div
    class="w-screen h-screen overflow-hidden flex flex-col gap-4 bg-indigo-300 p-8 items-center justify-center"
>
    <h1 class="text-8xl font-black text-indigo-800">Frametool</h1>
    <p class="text-xl">Maak makkelijk frame generators voor profielfoto's.</p>
    <button
        on:click={() => {
            uploadModal = true;
        }}
        class="bg-indigo-500 rounded-full text-xl font-bold text-white px-4 py-2 transition-all hover:scale-105 hover:-rotate-3 hover:shadow-lg hover:bg-indigo-600 active:bg-indigo-800"
        >↑ Upload frame</button
    >
</div>
