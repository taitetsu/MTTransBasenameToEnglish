package SetTranslatedBasename;
use strict;

use LWP::UserAgent;

sub config_template {
    my ( $plugin, $config, $scope ) = @_;

    my ($prefix) = split ':', $scope;
    my $selected_lang
        = $plugin->get_config_value( $prefix . '_lang', $scope );

    my $lcs = MT->registry("set_translated_basename_language_codes");
    my @language_codes;
    foreach my $code ( keys %$lcs ) {
        my %row = (
            code => $code,
            name => $lcs->{$code},
        );
        $row{selected} = 1 if $selected_lang eq $code;
        push @language_codes, \%row;
    }
    @language_codes = sort { $a->{name} cmp $b->{name} } @language_codes;

    $plugin->load_tmpl(
        $prefix . '_setting.tmpl',
        { language_codes => \@language_codes },
    );
}

sub hdlr_template_param_edit_entry {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $host_node = $tmpl->getElementById('basename');

    my $plugin    = MT->component('SetTranslatedBasename');
    my $tmpl_file = File::Spec->catdir( $plugin->path, 'tmpl', 'include',
        'transformer_trans_text.tmpl' );
    my $include_node
        = $tmpl->createElement( 'include', { name => $tmpl_file, } );

    $tmpl->insertAfter( $include_node, $host_node );
}

sub translate_basename {
    my $app        = shift;
    my $trans_text = $app->param('trans_text');
    my $blog_id    = 'blog:' . $app->param('blog_id');

    my $plugin = MT->component('SetTranslatedBasename');

    my $client_id = $plugin->get_config_value( 'blog_client_id', $blog_id )
        || $plugin->get_config_value( 'system_client_id', 'system' );
    my $client_secret
        = $plugin->get_config_value( 'blog_client_secret', $blog_id )
        || $plugin->get_config_value( 'system_client_secret', 'system' );
    my $lang = $plugin->get_config_value( 'blog_lang', $blog_id )
        || $plugin->get_config_value( 'system_lang', 'system' );

    my $ua = MT->new_ua;
    $ua->agent( join '/', 'SetTranslatedBasename', $plugin->version );
    $ua->timeout(10);
    my $enc = $app->config->PublishCharset;
    my $req;
    my @qs;
    my $qs;
    my $res;

    $req = HTTP::Request->new(
        POST => "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13" );
    $req->content_type("application/x-www-form-urlencoded; charset=$enc");
    push @qs, 'grant_type=' . MT::Util::encode_url('client_credentials');
    push @qs, 'client_id=' . MT::Util::encode_url($client_id);
    push @qs, 'client_secret=' . MT::Util::encode_url($client_secret);
    push @qs,
        'scope=' . MT::Util::encode_url('http://api.microsofttranslator.com');
    $qs = join '&', @qs;
    $req->content($qs);
    $res = $ua->request($req);

    require JSON;
    my $access_token = JSON::from_json( $res->content )->{access_token};

    my $url
        = "http://api.microsofttranslator.com/V2/Http.svc/Translate?from="
        . $lang
        . "&to=en&text="
        . MT::Util::encode_url($trans_text);
    $ua->default_header( 'authorization' => 'Bearer ' . $access_token );
    $req = HTTP::Request->new( GET => $url );
    $req->content_type("application/x-www-form-urlencoded; charset=$enc");
    $res = $ua->request($req);

    my $result = $res->content;
    $result =~ s/<.*?>//g;
    $result = lc($result);
    $result =~ s/('|\.|=)//g;
    $result =~ s/\s/_/g;
    $result =~ s/__/_/g;
    return $app->json_result($result);
}

1;
