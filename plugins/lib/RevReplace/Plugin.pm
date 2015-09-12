package RevReplace::Plugin;

use strict;
use JSON::XS;

sub hdlr_sub {
    my ($cb, %args) = @_;
    # my $file = $args{file} || return 1;
    my $content_ref = $args{'content'};
    my $setting_blog_id = $args{'blog'}->parent_id || $args{'blog'}->id;
    my $plugin = MT->component('RevReplace');
    my $manifest_path = $plugin->get_config_value('path_setting', 'blog:' . $setting_blog_id);

    # 一括読み込み
    # http://www.meibinlab.jp/nishijima/archives/84
    open(IN, "<$manifest_path");
    local $/ = undef;
    my @filedata = <IN>;
    close(IN);

    # JSON解析
    # http://www2u.biglobe.ne.jp/~MAS/perl/waza/jsonread.html
    # http://yut.hatenablog.com/entry/20120516/1337124582
    my $items = JSON::XS->new()->decode(@filedata);

    while((my $key, my $value) = each($items)) {
        if ($key =~ /\.css$/) {
            $$content_ref =~ s/<link(.*)href="(.*)$key/<link$1href="$2$value/;
        }

        if ($key =~ /\.js$/) {
        }
    }
}

1;
