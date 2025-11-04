export function assertConstantsExist(): string | null {
  if (typeof API_URL != "string") {
    return "VITE_SERVER_URL not set"
  }
  return null
}
export const API_URL: string = import.meta.env.VITE_SERVER_URL;
