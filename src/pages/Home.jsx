import HomeStory from '../content/home.mdx'

export default function Home() {
  return (
    <>
      <section className="max-w-4xl mx-auto px-6 pt-20 pb-20 text-center">
        <img
          src="/logos/lock_hart_logo_FINAL.svg"
          alt=""
          className="w-24 h-24 md:w-32 md:h-32 mx-auto mb-8"
        />
        <p className="font-ui text-xs uppercase tracking-widest text-ink/70 mb-6">
          Legacy, Carried.
        </p>
        <h1 className="font-display text-5xl md:text-7xl leading-tight mb-8">
          Lock &amp; Hart
        </h1>
        <p className="font-display text-2xl md:text-3xl italic text-ink/80 max-w-2xl mx-auto">
          The Lockhart story — integrated for the first time.
        </p>
      </section>

      <article className="prose max-w-2xl mx-auto px-6 pb-24">
        <HomeStory />
      </article>
    </>
  )
}
