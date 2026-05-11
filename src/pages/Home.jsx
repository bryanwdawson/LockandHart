import { Link } from 'react-router-dom'
import HomeStory from '../content/home.mdx'
import StoryTag from '../components/StoryTag.jsx'

export default function Home() {
  return (
    <>
      <section className="max-w-4xl mx-auto px-6 pt-24 pb-20 text-center">
        <p className="font-ui text-xs uppercase tracking-widest text-ink/60 mb-6">
          Legacy, Carried.
        </p>
        <h1 className="font-display text-5xl md:text-7xl leading-tight mb-8">
          Lock &amp; Hart
        </h1>
        <p className="font-display text-2xl md:text-3xl italic text-ink/80 max-w-2xl mx-auto">
          The Lockhart story — integrated for the first time.
        </p>
      </section>

      <article className="prose max-w-2xl mx-auto px-6 pb-20">
        <HomeStory components={{ StoryTag }} />
      </article>

      <section className="max-w-4xl mx-auto px-6 pb-24 grid md:grid-cols-2 gap-12">
        <Link
          to="/japan"
          className="group block border border-silver/40 p-8 hover:border-ink transition"
        >
          <p className="font-ui text-xs uppercase tracking-widest text-ink/60 mb-3">
            Travelogue
          </p>
          <h3 className="font-display text-2xl mb-2">Japan — 2026</h3>
          <p className="text-ink/70">
            A self-contained recap of the trip.
          </p>
          <p className="font-ui text-xs uppercase tracking-widest mt-6 group-hover:underline">
            Enter →
          </p>
        </Link>
        <Link
          to="/shop"
          className="group block border border-silver/40 p-8 hover:border-ink transition"
        >
          <p className="font-ui text-xs uppercase tracking-widest text-ink/60 mb-3">
            Coming
          </p>
          <h3 className="font-display text-2xl mb-2">The First Pieces</h3>
          <p className="text-ink/70">
            Pendant. Lee Penny commemorative. Heart-leaf hoya.
          </p>
          <p className="font-ui text-xs uppercase tracking-widest mt-6 group-hover:underline">
            Preview →
          </p>
        </Link>
      </section>
    </>
  )
}
