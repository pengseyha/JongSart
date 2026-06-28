import { BadRequestException } from "@nestjs/common";

export function requireText(body: object, field: string): string {
  const value = (body as Record<string, unknown>)[field];
  if (typeof value !== "string" || value.trim().length === 0) {
    throw new BadRequestException(`${field} is required.`);
  }
  return value.trim();
}

export function optionalText(body: object, field: string): string | undefined {
  const value = (body as Record<string, unknown>)[field];
  if (value === undefined || value === null) return undefined;
  if (typeof value !== "string") {
    throw new BadRequestException(`${field} must be a string.`);
  }
  const trimmed = value.trim();
  return trimmed.length === 0 ? undefined : trimmed;
}
