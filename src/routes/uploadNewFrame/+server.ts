import { json } from "@sveltejs/kit"
import prisma from "$lib/prisma"

export async function POST({ request }) {
    const data = await request.json()

    if (await prisma.campaign.findUnique({where: {slug: data.slug}})) {
        return json({error: "Slug already exists"}, {status: 409})
    }

    // TODO: check integriteit van slug

    const db_item = await prisma.campaign.create({
        data,
    })

    return json({ db_item }, { status: 201 })
}