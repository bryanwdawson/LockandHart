export default function Footer() {
  const year = new Date().getFullYear()
  return (
    <footer className="border-t border-silver/30 mt-24">
      <div className="max-w-6xl mx-auto px-6 py-10 flex flex-col md:flex-row items-center justify-between gap-4">
        <p className="font-display text-lg">Lock &amp; Hart</p>
        <p className="font-ui text-xs uppercase tracking-widest text-ink/50">
          Legacy, Carried. &middot; &copy; {year}
        </p>
      </div>
    </footer>
  )
}
