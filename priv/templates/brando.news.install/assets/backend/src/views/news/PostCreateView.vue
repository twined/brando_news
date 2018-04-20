<template>
  <div class="create-post">
    <div class="container">
      <div class="card">
        <div class="card-header">
          <h5 class="section mb-0">Opprett nyhetspost</h5>
        </div>
        <div class="card-body">
          <KInputSelect
            v-model="post.status"
            :value="post.status"
            :options="[
              { name: 'Utkast', value: 'draft' },
              { name: 'Venter', value: 'pending' },
              { name: 'Publisert', value: 'published' },
              { name: 'Slettet', value: 'deleted' }
            ]"
            name="post[status]"
            label="Status"
            v-validate="'required'"
            data-vv-name="post[status]"
            data-vv-value-path="innerValue"
            :has-error="errors.has('post[status]')"
            :error-text="errors.first('post[status]')"
          />

          <KInputSelect
            v-model="post.language"
            :value="post.language"
            :options="[
              { name: 'English', value: 'en' },
              { name: 'Norsk', value: 'no' }
            ]"
            name="post[language]"
            label="Språk"
            v-validate="'required'"
            data-vv-name="post[language]"
            data-vv-value-path="innerValue"
            :has-error="errors.has('post[language]')"
            :error-text="errors.first('post[language]')"
          />

          <KInput
            v-model="post.header"
            :value="post.header"
            name="post[header]"
            type="text"
            label="Tittel"
            placeholder="Tittel"
            v-validate="'required'"
            data-vv-name="post[header]"
            data-vv-value-path="innerValue"
            :has-error="errors.has('post[header]')"
            :error-text="errors.first('post[header]')"
          />

          <KInputSlug
            v-model="post.slug"
            :value="post.slug"
            :from="post.header"
            name="post[slug]"
            type="text"
            label="URL-tamp"
            v-validate="'required'"
            data-vv-name="post[slug]"
            data-vv-value-path="innerValue"
            :has-error="errors.has('post[slug]')"
            :error-text="errors.first('post[slug]')"
          />

          <div class="row">
            <div class="col">
              <KInputMultiSelect
                v-model="post.illustrators"
                :value="post.illustrators"
                :options="illustrators"
                optionValueKey="id"
                optionLabelKey="name"
                name="post[illustrators]"
                label="Illustratører knyttet til posten"
                data-vv-name="post[illustrators]"
                data-vv-value-path="innerValue"
                :has-error="errors.has('post[illustrators]')"
                :error-text="errors.first('post[illustrators]')"
              />
            </div>
            <div class="col">
              <KInputMultiSelect
                v-model="post.clients"
                :value="post.clients"
                :options="clients"
                optionValueKey="id"
                optionLabelKey="name"
                name="post[clients]"
                label="Kunder/byråer knyttet til posten"
                data-vv-name="post[clients]"
                data-vv-value-path="innerValue"
                :has-error="errors.has('post[clients]')"
                :error-text="errors.first('post[clients]')"
              />
            </div>
          </div>

          <ModalAddClient
            :showModal="showAddClientModal"
            @close="closeAddClientModal"
            :saveCallback="onClientSave"
          />
          <button class="btn btn-outline-secondary mb-4" @click.prevent="openAddClientModal">
            Legg til kunde/byrå
          </button>

          <Villain
            :value="post.data"
            @input="post.data = $event"
            label="Innhold"
          />

          <div class="row">
            <div class="col">
              <KInputTextarea
                v-model="post.meta_description"
                :rows="2"
                name="post[meta_description]"
                type="text"
                label="META beskrivelse (for søkemotorer)"
                data-vv-name="post[meta_description]"
                data-vv-value-path="innerValue"
                :has-error="errors.has('post[meta_description]')"
                :error-text="errors.first('post[meta_description]')"
              />

              <KInputTextarea
                v-model="post.meta_keywords"
                :rows="1"
                name="post[meta_keywords]"
                type="text"
                label="META nøkkelord (for søkemotorer)"
                data-vv-name="post[meta_keywords]"
                data-vv-value-path="innerValue"
                :has-error="errors.has('post[meta_keywords]')"
                :error-text="errors.first('post[meta_keywords]')"
              />

              <KInputDatetime
                v-model="post.publish_at"
                :value="post.publish_at"
                name="post[publish_at]"
                type="text"
                label="Publiseringsdato"
                v-validate="'required'"
                data-vv-name="post[publish_at]"
                data-vv-value-path="innerValue"
                :has-error="errors.has('post[publish_at]')"
                :error-text="errors.first('post[publish_at]')"
              />

              <KInputCheckbox
                v-model="post.featured"
                :value="post.featured"
                name="post[featured]"
                label="Vektet post. (Vises øverst i oversikt)"
                data-vv-name="post[featured]"
                data-vv-value-path="innerValue"
                :has-error="errors.has('post[featured]')"
                :error-text="errors.first('post[featured]')"
              />
            </div>
            <div class="col">
              <KInputImage
                v-model="post.cover"
                name="post[cover]"
                label="Omslag"
                v-validate="'required'"
                data-vv-name="post[cover]"
                data-vv-value-path="innerValue"
                :has-error="errors.has('post[cover]')"
                :error-text="errors.first('post[cover]')"
              />
            </div>
          </div>

          <button :disabled="!!loading" @click="validate" class="btn btn-secondary">
            Lagre nyhetspost
          </button>

          <router-link :disabled="!!loading" :to="{ name: 'posts' }" class="btn btn-outline-secondary">
            Tilbake til oversikten
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

import nprogress from 'nprogress'
import showError from 'kurtz/lib/utils/showError'
import { postAPI } from '@/api/post'
import ModalAddClient from '@/components/clients/modals/ModalAddClient'

export default {
  components: {
    ModalAddClient
  },

  data () {
    return {
      showAddClientModal: false,
      loading: 0,
      illustrators: [],
      clients: [],
      agencies: [],
      post: {
        header: '',
        slug: '',
        data: '',

        illustrators: [],
        clients: [],

        cover: '',

        status: 'pending',
        language: 'en',
        featured: false,
        meta_description: '',
        meta_keywords: ''
      }
    }
  },

  inject: [
    'adminChannel'
  ],

  created () {
    this.listIllustrators()
    this.listAgencies()
    this.listClients()
  },

  methods: {
    onClientSave (client) {
      this.clients = [client, ...this.clients]
      this.agencies = [client, ...this.agencies]
    },

    openAddClientModal () {
      this.showAddClientModal = true
    },

    closeAddClientModal () {
      this.showAddClientModal = false
    },

    listIllustrators () {
      this.adminChannel.channel
        .push('illustrators:list')
        .receive('ok', payload => {
          this.illustrators = payload.illustrators
        })
    },

    listAgencies () {
      this.adminChannel.channel
        .push('agencies:list')
        .receive('ok', payload => {
          this.agencies = payload.agencies
        })
    },

    listClients () {
      this.adminChannel.channel
        .push('clients:list')
        .receive('ok', payload => {
          this.clients = payload.clients
        })
    },

    validate () {
      this.$validator.validateAll().then(() => {
        this.save()
      }).catch(err => {
        console.log(err)
        alert('Feil i skjema', 'Vennligst se over og rett feil i rødt')
        this.loading = false
      })
    },

    async save () {
      let params = Object.assign({}, this.post)

      params.illustrators = params.illustrators.map(i => parseInt(i.id))
      params.clients = params.clients.map(i => parseInt(i.id))

      try {
        nprogress.start()
        this.loading++
        await postAPI.createPost(params)
        nprogress.done()
        this.loading--
        this.$toast.success({message: 'Post opprettet'})
        this.$router.push({ name: 'posts' })
      } catch (err) {
        this.loading--
        showError(err)
      }
    }
  }
}
</script>

<style lang="css">
</style>
