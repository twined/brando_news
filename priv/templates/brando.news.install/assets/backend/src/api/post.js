import apollo from 'kurtz/lib/api/apolloClient'
import { handleErr } from 'kurtz/lib/api/errorHandler.js'

import POST_QUERY from './graphql/posts/POST_QUERY.graphql'
import POSTS_QUERY from './graphql/posts/POSTS_QUERY.graphql'
import CREATE_POST_MUTATION from './graphql/posts/CREATE_POST_MUTATION.graphql'
import UPDATE_POST_MUTATION from './graphql/posts/UPDATE_POST_MUTATION.graphql'

const postAPI = {
  /**
   * getPosts - get all news
   *
   * @return {Object}
   */
  async getPosts () {
    try {
      const result = await apollo.client.query({
        query: POSTS_QUERY,
        fetchPolicy: 'network-only'
      })
      return result.data.posts
    } catch (err) {
      handleErr(err)
    }
  },

  /**
   * getPost
   *
   * @param {Number}
   * @return {Object}
   */
  async getPost (postId) {
    try {
      const result = await apollo.client.query({
        query: POST_QUERY,
        variables: {
          postId
        },
        fetchPolicy: 'network-only'
      })
      return result.data.post
    } catch (err) {
      handleErr(err)
    }
  },

  /**
   * createPost - Mutation for creating post
   *
   * @param {Object} postParams
   * @return {Object}
   */
  async createPost (postParams) {
    try {
      const result = await apollo.client.mutate({
        mutation: CREATE_POST_MUTATION,
        variables: {
          post_params: postParams
        },
        fetchPolicy: 'network-only'
      })
      return result.data.create_post
    } catch (err) {
      handleErr(err)
    }
  },

  /**
   * updatePost - Mutation for updating post
   *
   * @param {Object} postParams
   * @return {Object}
   */
  async updatePost (postId, postParams) {
    try {
      const result = await apollo.client.mutate({
        mutation: UPDATE_POST_MUTATION,
        variables: {
          post_id: postId,
          post_params: postParams
        },
        fetchPolicy: 'network-only'
      })
      return result.data.update_post
    } catch (err) {
      handleErr(err)
    }
  }
}

export {
  postAPI
}
