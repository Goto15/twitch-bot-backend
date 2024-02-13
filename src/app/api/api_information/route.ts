import { NextRequest, NextResponse } from "next/server";
import prisma from "../../../lib/prisma";
import { Prisma } from "@prisma/client";

export async function POST(request: NextRequest) {
    const data = await request.nextUrl.searchParams

    const token: Prisma.TokenCreateInput = {
        access_token: data.get("access_token") || '',
        expires_in: Number(data.get("expires_in")),
        refresh_token: data.get("refresh_token"),
        token_name: data.get("token_name") || 'unknown_token',
        token_type: data.get("token_type"),
        scope: data.get("scope")
    }
    
    const return_token = await prisma.token.create({ data: token })
    return NextResponse.json(return_token);
}
