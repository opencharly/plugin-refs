// plugin-refs's OWN self-contained CUE schema — the SINGLE SOURCE for this plugin's
// declaration surface, served over the Describe channel (there is no schema-less
// plugin). SELF-CONTAINED: it references no base def, so it compiles STANDALONE (the
// property the SDK's serve-side compile and `cue exp gengotypes` both need).
//
// `refs:refs` is the swappable remote-repo fetch backend. The host keeps the fetch
// ORCHESTRATION (local-override resolution, cache-hit short-circuit) and only a genuine
// cache miss reaches this backend, which turns the wire input below into a populated
// local cache tree.
#RefsPlugin: {
	// The capability class:word the plugin serves.
	refs: "refs"

	// What the backend does, in one line (the public-docs surface).
	contract: string & !=""

	// The wire input each cache-miss download carries (mirrors spec.RefsDownloadInput).
	input?: {
		repo_path!: string & !=""
		version!:   string & !=""
	}
}
