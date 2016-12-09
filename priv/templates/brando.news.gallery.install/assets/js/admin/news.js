import $ from 'jquery';

import brando from 'brando';

export default class News {
  static setup() {
    News.setupI18n();
    let ppForm = new brando.PopupForm(
      'gallery', brando.language, News.seriesInsertionSuccess, [],
      {image_category_id: $('.create-series').attr('data-category-id')}
    );
    $('.create-series').click(() => {
      ppForm.show();
    });
  }

  static setupI18n() {
    const nbTranslations = {
      upload_images: 'Last opp bilder',
      creating_link: 'Oppretter galleri-lenke mellom post og bildeserie',
      link_created: 'Galleri-lenke opprettet!',
      inserted_image_series: 'Satt inn bildeserie',
    };
    const enTranslations = {
      upload_images: 'Upload images',
      creating_link: 'Creating gallery link between post and series',
      link_created: 'Gallery link created!',
      inserted_image_series: 'Inserted image series',
    };
    brando.i18n.addResourceBundle('nb', 'gallery', nbTranslations);
    brando.i18n.addResourceBundle('en', 'gallery', enTranslations);
  }

  static seriesInsertionSuccess(fields) {
    var html = $(`
      <ul class="tasks">
        <li>
          ${brando.i18n.t('gallery:inserted_image_series')} <strong>${fields.slug}</strong>
        </li>
      </ul>
    `);
    html.insertAfter('.create-series');
    var item = $(`<li>${brando.i18n.t('gallery:creating_link')}</li>`);
    item.appendTo($('.tasks'));
    $('.create-series').fadeOut();

    // create gallery
    $.ajax({
      headers: {
        Accept: 'application/json; charset=utf-8',
      },
      type: 'POST',
      data: {gallery: {imageseries_id: fields.id}},
      url: brando.Utils.addToPathName('create-gallery'),
    })
    .done($.proxy((data) => {
      /**
       * Callback after confirming.
       */
      if (data.status === '200') {
        var item = $(`<li>${brando.i18n.t('gallery:link_created')}</li>`);
        item.appendTo($('.tasks'));
        item = $(`
          <div>
            <a href="${data.href}" class="btn btn-default">
              ${brando.i18n.t('gallery:upload_images')}
            </a>
          </div>
        `);
        item.insertAfter($('.tasks'));
      } else {
        console.log('failed!');
      }
    }));
  }
}
