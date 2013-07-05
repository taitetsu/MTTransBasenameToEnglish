package SetTranslatedBasename;
use strict;

use LWP::UserAgent;

sub hdlr_template_param_edit_entry {
    my ($cb, $app, $param, $tmpl) = @_;

    my $host_node = $tmpl->getElementById('basename');
    my $innerHTML = <<HTML;
<input type="text" name="trans_text" id="trans_text" class="full-width" mt:watch-change="1" value="<mt:var name="trans_text" escape="html">" autocomplete="off" />
<input type="button" id="copy_title" name="copy_title" value="Copy Title" />
<input type="button" id="translate_basename" name="translate_basename" value="Translate" />
<mt:setvarblock name="jq_js_include" append="1">
  jQuery('#copy_title').click( function() {
    jQuery('#trans_text').val( jQuery('#title').val() );
  });

  jQuery('#translate_basename').click( function() {
    var trans_text = jQuery('#trans_text').val();
    jQuery.ajax({
      type: 'POST',
      contentType: 'application/x-www-form-urlencoded; charset=utf-8',
      async: true,
      url: '<mt:var name="script_url">',
      dataType: 'json',
      data: {
        __mode: 'translate_basename',
        blog_id: '<mt:var name="blog_id">',
        trans_text: trans_text
      },
      success: function(data) {
        jQuery('#basename').val(data.result)
      },
      error: function(xhr, status, error) {
        alert( trans('Translation Error (HTTP status code: [_1]. Message: [_2])', xhr.status, error) );
      }
    });
  });
</mt:setvarblock>
HTML

    my $block_node = $tmpl->createElement(
        'app:setting',
        {
            id => 'trans_text',
            label => 'Japanese',
            label_class => 'top-label',
        }
    );

    $block_node->innerHTML( $innerHTML );
    $tmpl->insertAfter($block_node, $host_node);
}

sub translate_basename {
    my $app = shift;
    my $trans_text = $app->param('trans_text');
    my $blog_id = 'blog:' . $app->param('blog_id');

    my $plugin = MT->component('SetTranslatedBasename');

    my $client_id     = $plugin->get_config_value('client_id', $blog_id);
    my $client_secret = $plugin->get_config_value('client_secret', $blog_id);
    my $lang          = $plugin->get_config_value('lang', $blog_id);

    my $ua = MT->new_ua;
    $ua->agent(join '/', 'SetTranslatedBasename', $plugin->version);
    $ua->timeout(10);
    my $enc = $app->config->PublishCharset;
    my $req;
    my @qs;
    my $qs;
    my $res;

    $req = HTTP::Request->new( POST => "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13" );
    $req->content_type("application/x-www-form-urlencoded; charset=$enc");
    push @qs, 'grant_type=' . MT::Util::encode_url('client_credentials');
    push @qs, 'client_id=' . MT::Util::encode_url($client_id);
    push @qs, 'client_secret=' . MT::Util::encode_url($client_secret);
    push @qs, 'scope=' . MT::Util::encode_url('http://api.microsofttranslator.com');
    $qs = join '&', @qs;
    $req->content($qs);
    $res = $ua->request($req);

    my $access_token = MT::Util::from_json($res->content)->{access_token};

    my $url = "http://api.microsofttranslator.com/V2/Http.svc/Translate?from=" . $lang . "&to=en&text=";
    $url .= MT::Util::encode_url($trans_text);
    $ua->default_header( 'authorization' => 'Bearer ' . $access_token );
    $req = HTTP::Request->new( GET => $url );
    $req->content_type("application/x-www-form-urlencoded; charset=$enc");
    $res = $ua->request($req);

    my $result = $res->content;
    $result =~ s/<.*?>//g;;
    $result = lc($result);
    $result =~ s/\s/_/g;
    $result =~ s/'//g;
    $result =~ s/\.//g;
    return $app->json_result($result);
}

1;
