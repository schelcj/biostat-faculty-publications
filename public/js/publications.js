if (typeof(jQuery) != 'undefined') { (function($) {
  $(function() {
    var common_words = {
      'is':    1,
      'as':    1,
      'an':    1,
      'am':    1,
      'so':    1,
      'by':    1,
      'to':    1,
      'on':    1,
      'us':    1,
      'of':    1,
      'in':    1,
      'at':    1,
      'do':    1,
      'or':    1,
      'ii':    1,
      'iii':   1,
      'not':   1,
      'and':   1,
      'are':   1,
      'the':   1,
      'for':   1,
      'via':   1,
      'its':   1,
      'but':   1,
      'with':  1,
      'from':  1,
      'into':  1,
      'their': 1
    };

    function get_top_five(obj) {
      var sorted = new Array;
      var params = new Array;

      Object.keys(obj).sort(function(a, b) {
        if (obj[a] > obj[b])
          return -1;

        if (obj[a] < obj[b])
          return 1;

        return 0;
      }).map(function(v, i) {
        var new_obj = new Object;
        new_obj[v] = obj[v];
        sorted.push(new_obj);
      });

      sorted.slice(0, 5).map(function(v, i) {
        var keys = Object.keys(v);
        params.push({'name': keys[0]});
      });

      return params;
    }

    $.getJSON('json/faculty.json?' + Date.now(), function(data) {
      $(data).each(function(i,e) {
        $('#faculty').append($('<option />', {id: e.uniqname, text: e.realname}));
      });

      $('#faculty').select2({
        placeholder:       'Select a faculty member',
        width:             'resolve',
        dropdownAutoWidth: true,
      });
    });

    $('#faculty').change(function() {
      var uniqname = $('select#faculty option:selected').attr('id');
      $('#cloud').empty();

      $.getJSON('json/faculty/' + uniqname + '.json?' + Date.now(), function(data) {
        var publications    = new Array;
        var publication_map = new Object;
        var co_authors      = new Object;
        var journals        = new Object;
        var words           = new Object;
        var word_cloud      = new Array;

        $(data.publications.article).each(function(index, article) {
          publications.push([
            article.title,
            article.timescited,
            article.scopusEID,
            article.author,
            article.year,
            article.journalTitle,
            article.journalVolume,
            article.pages
          ]);

          publication_map[article.scopusEID] = {
            title:   article.title,
            cited:   article.timescited,
            author:  article.author,
            journal: article.journalTitle,
            year:    article.year,
            url:     article.pubmedURL,
            pmid:    article.pmid,
            abst:    ''
          };

          var c = isNaN(journals[article.journalTitle]) ? 0 : journals[article.journalTitle];
          c++;
          journals[article.journalTitle] = c;

          var authors = article.clean_author.split('; ');
          for (var author in authors) {
            if (authors[author].toLowerCase() != data.umod_realname.toLowerCase()) {
              var count = isNaN(co_authors[authors[author]]) ? 0 : co_authors[authors[author]];
              count++;
              co_authors[authors[author]] = count;
            }
          }

          article.title.split(' ').map(function(v, i) {
            var word = v.toLowerCase();

            if (v.length == 1)
              return;

            if ($.isNumeric(v) == true)
              return;

            if (isNaN(common_words[word]) == false)
              return;

            var starts_with_numbers = /^\d+/;
            if (starts_with_numbers.test(word) == true)
              return;

            var starts_with_non_alpha = /^\W+/;
            if (starts_with_non_alpha.test(word) == true)
              return;

            var starts_with_dio = /^doi:/;
            if (starts_with_dio.test(word) == true)
              return;

            var contains_html = /<|>/;
            if (contains_html.test(word) == true)
              return;

            var count = isNaN(words[word]) ? 0 : words[word];
            count++;
            words[word] = count;
          });
        });

        Object.keys(words).sort(function(a, b) {
          if (words[a] > words[b])
            return -1;

          if (words[a] < words[b])
            return 1;

          return 0;
        }).splice(0, 50).map(function(v, i) {
          word_cloud.push({
            text: v,
            weight: words[v],
            link: {
              href:  '#',
              class: 'cloud',
              title: v
            },
            handlers: {
              click: function() {
                $('input[type=search]').val(v).focus().keyup();
                return false;
              }
            }
          });
        });

        $('#cloud').empty().jQCloud(word_cloud);

        var top_co_authors = get_top_five(co_authors);
        var top_journals   = get_top_five(journals);

        $('#pub-summary').removeClass('hide');
        $('#pub-summary #co-authors ul').empty().append($('#publication_summary_template').render(top_co_authors));
        $('#pub-summary #journals ul').empty().append($('#publication_summary_template').render(top_journals));

        $('#publications').dataTable({
          'autoWidth':  false,
          'processing': false,
          'destroy':    true,
          'data':      publications,
          'pageLength':  25,
          'order':       [[ 1, "desc" ]],
          'columns': [
            {'title': 'Title'     },
            {'title': 'Citations', 'width': '10%' },
            {'title': 'Scopus EID'},
            {'title': 'Authors'   },
            {'title': 'Year'      },
            {'title': 'Journal'   },
            {'title': 'Volume'    },
          ],
          'columnDefs': [{
            'targets':    [ 2, 3, 4, 5, 6 ],
            'visible':    false,
            'searchable': true
            },{
            'targets': [0],
            'createdCell': function (nTd, sData, oData, iRow, iCol) {
              var authors = oData[3].split(';');

              $('<a />', {
                href:   '#',
                text:   oData[0],
                id:     'scopuseid-' + oData[2],
                class:  'publication'
                }).appendTo($(nTd).empty());

              $(nTd).append($('#publication_title_template').render([{
                'author':  authors[0],
                'journal': oData[5],
                'volume':  oData[6],
                'pages':   oData[7],
                'year':    oData[4]
              }]));
            },
          }],
          'drawCallback': function(settings, json) {
            $('.publication').magnificPopup({
              type: 'inline',
              closeBtnInside: true,
              preloader: true,
              inline: {
                markup: $('#publication_container').html()
              },
              callbacks: {
                open: function() {
                  var mfp         = this;
                  var eid         = $(this.st.el).attr('id').slice(10);
                  var publication = publication_map[eid];

                  $.getJSON('json/abstracts/' + publication.pmid + '.json?' + Date.now(), function(data) {
                    publication['abst'] = data.abstract;
                  }).always(function() {
                    mfp.items = [publication];
                    mfp.index = 0;
                    mfp.updateItemHTML();
                  });
                },
                markupParse: function(template, values, item) {
                  var authors           = item.data.author.split('; ');
                  var primary_authors   = authors.splice(0,10);
                  var secondary_authors = authors.splice(10,authors.length);

                  var author_container = $(template).find('.pub-author');
                  $(author_container).append(primary_authors.join(', '));

                  if (secondary_authors.length > 0) {
                    var secondary_author_container = $('<div />', {id: 'secondary_authors'}).append(secondary_authors.join(', '));

                    $(author_container).append('&nbsp;').append(
                      $('<a />', {href: '#', id: 'show_more_authors'})
                      .text('More...')
                      .click(function() {
                        $(author_container).append(secondary_author_container);
                        $(this).hide();
                      })
                    );
                  }

                  $(template).find('a#pmid').attr('href', item.data.url);
                }
              }
            });
          },
        });
      });
    });
  });
})(jQuery)};
