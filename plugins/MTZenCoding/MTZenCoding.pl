package MT::Plugin::MTZenCoding;
use strict;
use warnings;
use base qw(MT::Plugin);
use vars qw($VERSION);
$VERSION = '0.0.5';

my $plugin = MT::Plugin::MTZenCoding->new({
    id => 'mtzencoding',
    key => __PACKAGE__,
    name => 'MT Zen-Coding',
    version => $VERSION,
    description => '<__trans phrase="Use Zen Coding textarea of Movable Type">',
    author_name => 'Tomohiro Okuwaki',
    author_link => 'http://www.tinybeans.net/blog/',
    plugin_link => 'http://www.tinybeans.net/blog/download/mt-plugin/mt-zen-coding.html',
    doc_link => 'http://code.google.com/p/zen-coding/',
    l10n_class => 'MTZenCoding::L10N',
    config_template => 'config.tmpl',
    settings => MT::PluginSettings->new([
        [ 'active', { Default => 0, Scope => 'system' } ],
        [ 'active', { Default => 1, Scope => 'blog' } ],
        [ 'active_tmpl', { Default => 0, Scope => 'system' } ],
        [ 'active_tmpl', { Default => 1, Scope => 'blog' } ],
    ]),
});
MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        callbacks => {
            'MT::App::CMS::template_source.header' => '$mtzencoding::MTZenCoding::Plugin::cb_tmpl_source_header',
            'MT::App::CMS::template_source.edit_template' => '$mtzencoding::MTZenCoding::Plugin::cb_tmpl_source_edit_template',
        },
    });
}

sub get_setting {
    my $plugin = shift;
    my ($key, $blog_id) = @_;

    my (%plugin_param, $value);
    if ($blog_id) {
        $plugin->load_config(\%plugin_param, 'blog:'.$blog_id);
        $value = $plugin_param{$key};
    }
    unless ($value) {
        $plugin->load_config(\%plugin_param, 'system');
        $value = $plugin_param{$key};
    }
    $value;
}

1;
