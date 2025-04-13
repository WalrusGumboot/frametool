import prisma from "$lib/prisma"
import { error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";

export const load = (async ({ params: { slug } }) => {
    const campaign = await prisma.campaign.findUnique({
        where: { slug },
        omit: { id: true }
    });


    if (campaign == null) {
        error(
            404, { message: "Not found" }
        )
    }

    return { campaign };
}) satisfies PageServerLoad;