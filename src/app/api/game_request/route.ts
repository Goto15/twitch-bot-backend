import { NextRequest, NextResponse } from "next/server";
import prisma from "../../../lib/prisma";
import { Prisma } from "@prisma/client";
import { URL } from "../../../constants/url";

export async function POST(request: NextRequest) {
    /* TODO
        1. Parse the request
            a. translate the reward_type into the specific reward
        2. Ask IGDB for game information
            a. If there are multiple get some clarification
        3. Add the game to the voting pool with updated information
        4. Give it a vote
    */

    const data = await request.nextUrl.searchParams
    let message = ''

    const reward_type = data.get("reward_type")
    const requested_game = data.get("requested_game")
    const requester = data.get("requester")
    const access_token = data.get("access_token")
    const client_id = data.get("client_id")
    const generic_error_message = "@benebeats help this goofball out!"

    const search_data = await fetch(`${URL.IGDB.games}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Client-ID': client_id,
            'Authorization': `Bearer ${access_token}`
        },
        body: `search "${requested_game}"; fields *;`
    })
    const games = await search_data.json()
    //TODO: complete whiff path resolution
    if (games.length === 0) {
        message = `THAT'S A COMPLETE WHIFF HOMIE!
                    ${generic_error_message}`
    }
    // TODO happy path resolution
    if (games.length === 1) {
        message = `GREAT SHOT HOMIE.
                ${games[0].name} has been added to the voting queue!
                You can double check that's the right game here: ${games[0].url}`
    }
    // TODO: too broad search resolution
    if (games.length > 1) {
        const games_string = games.map((game: any, iter: Number) => `${iter}. ${game.name}`).join(" ")
        message = `TOO BROAD HOMIE.
                    ${generic_error_message}
                    Which one did you mean: ${games_string}?`
    }


    // Grabs the genres of a game
    games.forEach(async game => {
        const game_genres = `(${game.genres.join(",")})`
        let genre = await fetch("https://api.igdb.com/v4/genres/", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Client-ID': client_id,
                'Authorization': `Bearer ${access_token}`
            },
            body: `fields *; where id = ${game_genres};`
        })
        genre = await genre.json()
        console.log("GENRES: ", genre)
    });

    return NextResponse.json({ message: message });
}
