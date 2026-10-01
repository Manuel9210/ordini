type RuntimeEnvironment = {
  DB?: any;
  BUCKET?: any;
  ASSETS?: any;
};

const injectedEnv = (globalThis as typeof globalThis & {
  __GESTIONE_ORDINI_ENV__?: RuntimeEnvironment;
}).__GESTIONE_ORDINI_ENV__;

let cloudflareEnv: RuntimeEnvironment = {};
if (!injectedEnv) {
  try {
    cloudflareEnv = (await import("cloudflare:workers")).env as RuntimeEnvironment;
  } catch {
    // The Aruba Node adapter injects bindings before loading the worker bundle.
  }
}

export const runtimeEnv = injectedEnv ?? cloudflareEnv;
