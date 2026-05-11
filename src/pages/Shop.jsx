import products from '../../data/products.json'

export default function Shop() {
  return (
    <section className="max-w-4xl mx-auto px-6 py-24">
      <p className="font-ui text-xs uppercase tracking-widest text-ink/60 mb-3 text-center">
        Sacred. Worn. Kept.
      </p>
      <h1 className="font-display text-5xl mb-4 text-center">The First Pieces</h1>
      <p className="text-center text-ink/70 mb-16 max-w-xl mx-auto">
        Three objects under development. None for sale yet.
      </p>

      <div className="grid md:grid-cols-3 gap-8">
        {products.items.map((p) => (
          <div key={p.slug} className="border border-silver/40 p-6">
            <p className="font-ui text-[10px] uppercase tracking-widest text-ink/50 mb-2">
              {p.category}
            </p>
            <h3 className="font-display text-xl mb-3">{p.name}</h3>
            <p className="text-sm text-ink/70 mb-4">{p.summary}</p>
            <p className="font-ui text-xs uppercase tracking-widest text-oxblood">
              {p.status}
            </p>
          </div>
        ))}
      </div>
    </section>
  )
}
