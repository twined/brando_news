<template>
  <div class="posts container" v-if="!loading" appear>
    <ImageSelection
      :selectedImages="selectedImages"
      :deleteCallback="deleteCallback"
    />
    <div class="row">
      <div class="col-md-12">
        <div class="card">
          <div class="card-header">
            <h5 class="section mb-0">Nyhetsposter</h5>
          </div>
          <div class="card-body">
            <div class="jumbotron text-center">
              <h1 class="display-1 text-uppercase text-strong">Nyheter</h1>
              <p class="lead">Administrér nyhetsposter og assosierte bildegallerier</p>
              <hr class="my-4">
              <p class="lead">
                <router-link :to="{ name: 'post-create' }" class="btn btn-secondary" exact>
                  Ny post
                </router-link>
              </p>
            </div>

            <table class="table table-airy" v-if="allPosts.length">
              <tbody name="slide-fade-top-slow" is="transition-group">
                <tr :key="post.id" v-for="post in allPosts">
                  <td class="fit">
                    <Status :status="post.status" />
                  </td>
                  <td>
                    <img :src="post.cover.thumb" class="avatar-sm img-border-lg" />
                  </td>
                  <td>
                    <strong>{{ post.header }}</strong>
                    <br />
                    <span
                      class="badge badge-xs badge-light mr-1 text-uppercase"
                      :key="i.id"
                      v-for="i in post.illustrators">
                      <i class="fal fa-fw fa-pencil-alt mr-1"> </i>
                      {{ i.name }}
                    </span>
                    <br v-if="post.clients.length" />
                    <span
                      class="badge badge-xs badge-light text-uppercase mr-1"
                      :key="i.id"
                      v-for="i in post.clients">
                      <i class="fal fa-fw fa-suitcase mr-1"> </i>
                      {{ i.name }}
                    </span>
                  </td>
                  <td class="fit">
                    <Flag :value="post.language" />
                  </td>
                  <td class="fit">
                    <template v-if="post.gallery && post.gallery.imageseries">
                      <ModalImageSeries
                        :selectedImages="selectedImages"
                        :imageSeriesId="post.gallery.imageseries.id"
                        @close="closeImageSeriesModal"
                        @delete="removeSeries"
                        v-if="showImageSeriesModal === post.gallery.imageseries.id"
                      />
                      <button @click.prevent="openImageSeriesModal(post.gallery.imageseries.id)" class="btn btn-white" v-b-popover.hover.top="'Rediger bilder'">
                        <i class="fal fa-fw fa-images"> </i>
                      </button>
                    </template>
                    <template v-else>
                      <button @click.prevent="createImageSeries(post)" class="btn btn-white" v-b-popover.hover.top="'Legg til bildeserie'">
                        <i class="fa fa-fw fa-plus"> </i>
                      </button>
                    </template>
                  </td>
                  <td class="fit text-xs">
                    {{ post.publish_at | datetime }}
                  </td>
                  <td class="text-center fit">
                    <b-dropdown variant="white" no-caret>
                      <template slot="button-content">
                        <i class="k-dropdown-icon"></i>
                      </template>
                      <router-link
                        :to="{ name: 'post-edit', params: { postId: post.id } }"
                        tag="button"
                        :class="{'dropdown-item': true}"
                        exact
                      >
                        <i class="fal fa-pencil fa-fw mr-2"></i>
                        Endre post
                      </router-link>
                      <button
                        @click.prevent="deletePost(post)"
                        :class="{'dropdown-item': true}"
                      >
                        <i class="fal fa-trash fa-fw mr-2"></i>
                        Slett post
                      </button>
                    </b-dropdown>
                  </td>
                </tr>
              </tbody>
            </table>
            <!-- <div v-if="allPosts.length">
              <button
                v-if="queryVars.offset !== 0"
                @click.prevent="previousPage"
                class="btn btn-outline-secondary">
                &larr; Forrige side
              </button>
              <button
                @click.prevent="nextPage"
                class="btn btn-outline-secondary">
                Neste side &rarr;
              </button>
            </div> -->
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import { alertConfirm } from 'kurtz/lib/utils/alerts'
import Status from 'kurtz/lib/components/Status'
import ModalAddVideo from '../../components/videos/modals/ModalAddVideo'
import ModalEditVideo from '../../components/videos/modals/ModalEditVideo'
import ModalCreateImageSeries from 'kurtz/lib/components/images/modals/ModalCreateImageSeries'
import ModalImageSeries from 'kurtz/lib/components/images/modals/ModalImageSeries'
import ImageSelection from 'kurtz/lib/components/images/ImageSelection'

export default {
  components: {
    Status,
    ModalAddVideo,
    ModalEditVideo,
    ModalCreateImageSeries,
    ModalImageSeries,
    ImageSelection
  },

  data () {
    return {
      category_id: null,
      loading: 0,
      showCreateImageSeriesModal: null,
      showImageSeriesModal: null,
      selectedImages: [],
      queryVars: {
        offset: 0,
        limit: 25
      }
    }
  },

  created () {
    console.log('created <PostListView />')
    this.adminChannel.channel
      .push('images:get_category_id_by_slug', { slug: 'post-galleries' })
      .receive('ok', payload => {
        this.category_id = payload.category_id
      })

    this.getData()
  },

  computed: {
    ...mapGetters('users', [
      'me'
    ]),
    ...mapGetters('posts', [
      'allPosts'
    ])
  },

  inject: [
    'adminChannel'
  ],

  methods: {
    async getData () {
      this.loading++
      await this.getPosts(this.queryVars)
      this.loading--
    },

    openImageSeriesModal (id) {
      console.log('open img ser', id)
      this.showImageSeriesModal = id
    },

    closeImageSeriesModal () {
      this.showImageSeriesModal = null
    },

    openCreateImageSeriesModal (id) {
      this.showCreateImageSeriesModal = id
    },

    closeCreateImageSeriesModal () {
      this.showCreateImageSeriesModal = null
    },

    async createImageSeries (post) {
      // - create a new image series belonging to `this.category_id`
      // - connect it through post.gallery.imageseries_id
      // - open image series editing modal
      this.adminChannel.channel
        .push('images:create_image_series', { name: post.header, image_category_id: this.category_id })
        .receive('ok', seriesPayload => {
          this.$toast.success({message: 'Bildeserie opprettet'})
          this.adminChannel.channel
            .push('gallery:create', { post_id: post.id, imageseries_id: seriesPayload.series.id, creator_id: this.me.id })
            .receive('ok', galleryPayload => {
              this.$store.commit('posts/ADD_GALLERY_TO_POST', {postId: post.id, gallery: galleryPayload.gallery})
              this.$toast.success({message: 'Bildeserie knyttet til posten'})
              this.openImageSeriesModal(seriesPayload.series.id)
            })
        })
    },

    deletePost (post) {
      alertConfirm('OBS', 'Er du sikker på at du vil slette denne posten?', (data) => {
        if (!data) {
          return
        }

        this.adminChannel.channel
          .push('post:delete', { id: post.id })
          .receive('ok', payload => {
            this.$store.commit('posts/DELETE_POST', post.id)
          })
      })
    },

    nextPage () {
      this.queryVars.offset = this.queryVars.offset + this.queryVars.limit
      this.getData()
    },

    previousPage () {
      if (this.queryVars.offset >= this.queryVars.limit) {
        this.queryVars.offset = this.queryVars.offset - this.queryVars.limit
        this.getData()
      }
    },

    removeSeries (series) {
      console.log('removeseries')
      // series was removed - look for any matching series in our galleries
      this.allPosts.forEach(p => {
        if (p.gallery && p.gallery.imageseries) {
          console.log(p.gallery.imageseries.id, ' / ', series.id)
          if (parseInt(p.gallery.imageseries.id) === parseInt(series.id)) {
            this.$store.commit('posts/REMOVE_GALLERY_FROM_POST', p.id)
            this.$toast.success({message: 'Fjernet galleri fra post'})
          }
        }
      })
    },

    /**
     * Callback from ImageSelection when we delete images
     */
    deleteCallback () {
      // we don't need to do anything here, except closing modal, since we refetch image series anyway.
      this.closeImageSeriesModal()
    },

    ...mapActions('posts', [
      'getPosts'
    ])
  }
}
</script>
