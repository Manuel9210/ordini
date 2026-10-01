type RuntimeEnvironment = {
  DB?: any;
  BUCKET?: any;
  ASSETS?: any;
};

export const runtimeEnv = (globalThis as typeof globalThis & {
  __GESTIONE_ORDINI_ENV__?: RuntimeEnvironment;
}).__GESTIONE_ORDINI_ENV__ ?? {};
