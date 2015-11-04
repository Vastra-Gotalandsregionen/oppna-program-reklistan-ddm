<style>
  .btn-primary {
      color: #ffffff;
      text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);
      background-color: #006dcc;
      background-image: -moz-linear-gradient(top, #0088cc, #0044cc);
      background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#0088cc), to(#0044cc));
      background-image: -webkit-linear-gradient(top, #0088cc, #0044cc);
      background-image: -o-linear-gradient(top, #0088cc, #0044cc);
      background-image: linear-gradient(to bottom, #0088cc, #0044cc);
      background-repeat: repeat-x;
      border-color: #0044cc #0044cc #002a80;
      border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
      filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff0088cc', endColorstr='#ff0044cc', GradientType=0);
      filter: progid:DXImageTransform.Microsoft.gradient(enabled=false);
  }
  .btn {
      display: inline-block;
      padding: 4px 12px;
      margin-bottom: 0;
      font-size: 14px;
      line-height: 20px;
      color: #333333;
      text-align: center;
      text-shadow: 0 1px 1px rgba(255, 255, 255, 0.75);
      vertical-align: middle;
      cursor: pointer;
      background-color: #f5f5f5;
      background-image: -moz-linear-gradient(top, #ffffff, #e6e6e6);
      background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#ffffff), to(#e6e6e6));
      background-image: -webkit-linear-gradient(top, #ffffff, #e6e6e6);
      background-image: -o-linear-gradient(top, #ffffff, #e6e6e6);
      background-image: linear-gradient(to bottom, #ffffff, #e6e6e6);
      background-repeat: repeat-x;
      border: 1px solid #cccccc;
      border-color: #e6e6e6 #e6e6e6 #bfbfbf;
      border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
      border-bottom-color: #b3b3b3;
      -webkit-border-radius: 4px;
      -moz-border-radius: 4px;
      border-radius: 4px;
      filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffffff', endColorstr='#ffe6e6e6', GradientType=0);
      filter: progid:DXImageTransform.Microsoft.gradient(enabled=false);
      -webkit-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
      -moz-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
  }
  a.btn {
      color: #0088cc;
      text-decoration: none;
  }
</style>

<link href="/reklistan-theme/css/custom.css?browserId=other&themeId=reklistantheme_WAR_reklistantheme&languageId=en_US&b=6210&t=${.now?datetime?iso_local}" rel="stylesheet" type="text/css">
<div class="preview-wrapper">

  <div id="title-target"></div>
  <script id="title-template" type="text/x-handlebars-template">
    <h1 class="preview-article-title">{{title}}</h1>
    <div class="preview-printed-date only-print">Utskrivet {{date}}</div>
  </script>

  <div class="preview-settings">
    <a href="#" target="_blank" class="open-self-new-window btn btn-primary">För utskrift - öppna i nytt eget fönster</a>
    <label><input type="checkbox" class="chekbox-show-preview checkbox-show-preview-published-draft" name="preview-settings" value="show-draft-published">Visa utkast/publicerad</label>
    <label><input type="checkbox" class="chekbox-show-preview checkbox-show-preview-diff" name="preview-settings" value="show-diff" checked>Visa diff</label>
  </div>

  <div class="preview-box preview-box-draft hide-me">
    <div class="preview-box-heading">Utkast<span class="no-print"> (<a href="#" class="toggle-show-published">visa publicerad</a>)</span></div>
    <div id="draft-target"></div>
  </div>
  <div class="preview-box preview-box-published hide-me">
    <div class="preview-box-heading">Publicerad<span class="no-print"> (<a href="#" class="toggle-show-draft">visa utkast</a>)</span></div>
    <div id="published-target"></div>
  </div>    
  <div class="preview-box preview-box-diff single-preview-box">
    <div class="preview-box-heading">Diff</div>
    <div id="diff-target"></div>
  </div>
</div>

<script>
AUI().ready('aui-base', function(A) {
    'use strict';

    var urlJquery = '/reklistan-theme/custom-lib/jquery/jquery-1.11.2.min.js';
    var urlSwag = '/reklistan-theme/custom-lib/swag/swag.min.js';
    var urlHandlebars = '/reklistan-theme/lib/handlebars/handlebars.min.js';
    var urlDiff = '/reklistan-theme/custom-lib/diff.js/diff.js';
    var urlDiffPreviews = '/reklistan-theme/js/diff-previews.js';
    var urlHbsTemplate = '/reklistan-theme/handlebars/details-drugs.hbs';
    var urlArticlePublished = "/api/jsonws/skinny-web.skinny/get-skinny-journal-article/group-id/${articleGroupId}/article-id/${.vars['reserved-article-id'].data}/status/0/locale/${locale}";
    var urlArticleDraft = "/api/jsonws/skinny-web.skinny/get-skinny-journal-article/group-id/${articleGroupId}/article-id/${.vars['reserved-article-id'].data}/status/-1/locale/${locale}";    


    // Load jQuery
    A.Get.js(urlJquery, function (err) {
        if (err) {
            alert('Could not load jQuery, URL: ' + urlJquery);
            return;
        }
        // Load all javascript/handlebar templates/json needed.
        $(function() {
          $.when(
            $.getScript(urlHandlebars),
            $.getScript(urlSwag),
            $.getScript(urlDiff),
            $.getScript(urlDiffPreviews),
            $.ajax(urlHbsTemplate, {dataType: 'text'}),
            $.ajax(urlArticlePublished, {dataType: 'json'}),
            $.ajax(urlArticleDraft, {dataType: 'json'})
          )
          .then(function(voidHandlebars, voidSwag, voidDiff, voidDiffPreviews, hbsTemplate, articlePublished, articleDraft) {
            articlePublished = articlePublished[0];
            articleDraft = articleDraft[0];
            // Set variable to 'preview' so that we can pick it up in the handlebars template.
            articlePublished.isPreview = true;
            articleDraft.isPreview = true;
            renderDiffPreviews(articlePublished, articleDraft, hbsTemplate[0]);
          })
          .fail(function(/*jqXHR, textStatus, errorThrown*/) {
            alert('Kunda inte ladda alla filer!');
          });
        });

    });
});
</script>
