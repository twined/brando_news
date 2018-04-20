import nprogress from 'nprogress'
import {
  STORE_POST,
  STORE_POSTS,
  DELETE_POST,
  ADD_GALLERY_TO_POST,
  REMOVE_GALLERY_FROM_POST
} from '../mutation-types'

import { postAPI } from '../../api/post'

export const posts = {
  namespaced: true,
  // initial state
  state: {
    post: {},
    posts: []
  },

  // mutations
  mutations: {
    [DELETE_POST] (state, postId) {
      const p = state.posts.find(p => parseInt(p.id) === parseInt(postId))
      const pIdx = state.posts.indexOf(p)

      state.posts = [
        ...state.posts.slice(0, pIdx),
        ...state.posts.slice(pIdx + 1)
      ]
    },

    [STORE_POST] (state, post) {
      state.post = post
    },

    [STORE_POSTS] (state, posts) {
      state.posts = posts
    },

    [ADD_GALLERY_TO_POST] (state, {postId, gallery}) {
      const p = state.posts.find(p => parseInt(p.id) === parseInt(postId))
      const pIdx = state.posts.indexOf(p)

      const newP = {...p, gallery: gallery}

      state.posts = [
        ...state.posts.slice(0, pIdx),
        newP,
        ...state.posts.slice(pIdx + 1)
      ]
    },

    [REMOVE_GALLERY_FROM_POST] (state, postId) {
      const p = state.posts.find(p => parseInt(p.id) === parseInt(postId))
      const pIdx = state.posts.indexOf(p)

      const newP = {...p, gallery: null}

      state.posts = [
        ...state.posts.slice(0, pIdx),
        newP,
        ...state.posts.slice(pIdx + 1)
      ]
    }
  },

  getters: {
    allPosts: state => {
      return state.posts
    }
  },

  actions: {
    async getPosts (context, variables) {
      nprogress.start()
      const posts = await postAPI.getPosts(variables)
      context.commit(STORE_POSTS, posts)
      nprogress.done()
      return posts
    },

    async getPost (context, postId) {
      nprogress.start()
      const post = await postAPI.getPost(postId)
      context.commit(STORE_POST, post)
      nprogress.done()
      return post
    }
  }
}
