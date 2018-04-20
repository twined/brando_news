export default [
  {
    text: 'Nyheter',
    icon: 'fal fa-newspaper fa-fw',
    children: [
      {
        text: 'Oversikt',
        to: { name: 'posts' }
      },
      {
        text: 'Ny post',
        to: { name: 'post-create' }
      }
    ]
  }
]
