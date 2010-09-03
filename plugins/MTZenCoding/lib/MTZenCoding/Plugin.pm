package MTZenCoding::Plugin;
use strict;
use warnings;
use base qw(MT::Plugin);

sub cb_tmpl_source_header {
    my ($cb, $app, $tmpl_ref) = @_;
    
    # Get plugin setting
    my $plugin = MT->component('mtzencoding');
    my $blog = $app->blog;
    my $blog_id = defined($blog) ? $blog->id : '';
    my $active = $plugin->get_setting('active', $blog_id);

    return unless $active;

    my $static_path = $app->static_path;
    my $zen_js = '<script type="text/javascript" src="' . $static_path . 'plugins/MTZenCoding/zen_textarea.js"></script>'."\n";
    my $add_html_head = '<mt:setvarblock name="js_include" append="1">' . $zen_js . '</mt:setvarblock>';

    $$tmpl_ref = $add_html_head . $$tmpl_ref;
}

sub cb_tmpl_source_edit_template {
    my ($cb, $app, $tmpl_ref) = @_;
    
    # Get plugin setting
    my $plugin = MT->component('mtzencoding');
    my $blog = $app->blog;
    my $blog_id = defined($blog) ? $blog->id : '';
    my $active = $plugin->get_setting('active', $blog_id);
    my $active_tmpl = $plugin->get_setting('active_tmpl', $blog_id);

    return unless $active;
    return unless $active_tmpl;

    my $static_path = $app->static_path;
    
    # Replace codemirror.js
    my $codemirror = '<script type="text/javascript" src="<\$mt:var name="static_uri"\$>codemirror/js/codemirror.js\?v=<mt:var name="mt_version_id" escape="URL">"></script>';
    $$tmpl_ref =~ s!$codemirror!!g;
    
    # Add css and js
    my $add_css = '<mt:setvarblock name="html_head" append="1"><link rel="stylesheet" href="'.$static_path.'plugins/MTZenCoding/MTZenCoding.css" type="text/css" /></mt:setvarblock>'."\n";

    my $add_js = '<mt:setvarblock name="js_include" append="1"><script type="text/javascript" src="' . $static_path . 'plugins/MTZenCoding/MTZenCoding.js"></script></mt:setvarblock>'."\n";

    $$tmpl_ref = $add_css . $add_js . $$tmpl_ref;
}

1;