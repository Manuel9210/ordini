import type { Metadata } from "next";
import "./globals.css";
export const metadata: Metadata = { title: "Ordini Agenti", description: "Gestione clienti, ordini e consegne della rete agenti.", manifest: "/manifest.webmanifest", themeColor: "#101d2c", icons: { icon: "/favicon.svg", shortcut: "/favicon.svg", apple: "/icon-192.png" } };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="it"><body className="antialiased">{children}</body></html>; }
