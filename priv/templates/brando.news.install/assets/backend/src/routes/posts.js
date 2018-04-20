import PostCreateView from '@/views/news/PostCreateView'
import PostEditView from '@/views/news/PostEditView'
import PostListView from '@/views/news/PostListView'

export default [
  {
    path: '/nyheter',
    component: PostListView,
    name: 'posts'
  },

  {
    path: '/nyhet/ny',
    component: PostCreateView,
    name: 'post-create'
  },

  {
    path: '/nyhet/endre/:postId',
    component: PostEditView,
    name: 'post-edit',
    props: true
  }
]
