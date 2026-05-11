export default function Japan() {
  // The Japan recap is a self-contained static site dropped into public/japan/.
  // When the folder is present, this page redirects into it.
  // Until then, this is a placeholder.
  return (
    <section className="max-w-2xl mx-auto px-6 py-24 text-center">
      <p className="font-ui text-xs uppercase tracking-widest text-ink/60 mb-6">
        Travelogue
      </p>
      <h1 className="font-display text-5xl mb-6">Japan — 2026</h1>
      <p className="text-ink/70 mb-10">
        The recap lives at <code className="font-ui">/japan/</code>. Once the static folder
        is dropped into <code className="font-ui">public/japan/</code>, this route will hand
        off to it.
      </p>
      <a
        href="/japan/index.html"
        className="inline-block font-ui text-xs uppercase tracking-widest border border-ink px-6 py-3 hover:bg-ink hover:text-ivory transition"
      >
        Enter the recap →
      </a>
    </section>
  )
}
