const styles = {
  DOC: 'bg-ink/10 text-ink',
  TRAD: 'bg-oxblood/15 text-oxblood',
  LEG: 'bg-garnet/10 text-garnet',
}

const labels = {
  DOC: 'Documented',
  TRAD: 'Tradition',
  LEG: 'Legend',
}

export default function StoryTag({ t = 'DOC' }) {
  return (
    <span
      className={`inline-block px-2 py-0.5 text-[10px] font-ui uppercase tracking-widest rounded-sm ${styles[t]}`}
      title={`Story layer: ${labels[t]}`}
    >
      {labels[t]}
    </span>
  )
}
