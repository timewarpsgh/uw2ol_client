####### use modules 1 #############
use MIME::Base64 qw(encode_base64);
use Tk::Photo;
use PDL;
use Tk::Animation;
use Tk;
use Win32::Console::ANSI;
use Term::ANSIColor qw(:constants);
use Tk::PNG;
use AnyEvent;
use List::Util qw(); 
use Redis;
use IO::Handle;
use IO::Socket::RedisPubSub qw(subscribe pull);
use IO::Select;
use Time::HiRes;
use experimental 'smartmatch';
use threads;
use threads::shared;
use Array::Utils qw(array_minus);
use JSON;
use Imager;
use Win32::HideConsole;
PDL::no_clone_skip_warning;

############  add current directory to path ############## 
use Cwd qw(getcwd);
use File::Spec::Functions qw( canonpath );
push(@INC, canonpath(getcwd()));

############ secondary parts used by major parts ##############
require 'scripts\\secondary_parts\\pm_turn_array_to_w_map.pl';
require 'scripts\\secondary_parts\\pm_turn_bin_to_port_piddle_and_image.pl';
require 'scripts\\secondary_parts\\pm_make_transparent_sprites.pl';
require 'scripts\\secondary_parts\\pm_make_transparent_ship_sprites.pl';
require 'scripts\\secondary_parts\\pm_make_transparent_npcs.pl';
require 'scripts\\secondary_parts\\pm_ports_meta_data.pl';
require 'scripts\\secondary_parts\\pm_hash_ship_name_to_attributes.pl';
require 'scripts\\secondary_parts\\pm_utf8_gbk_conversion.pl';

####### share variables ###########
share(@on);
share(@mp);
share(@cx);
share(@cy);
share(@chat_message);
share(@ocean_day);
share(@water_all1);
share(@food_all1);
share(@lumber_all1);
share(@shot_all1);
share(@ai_x_y);
share(@pubmes);

####### major parts ###########
require 'scripts\\c_0_connection_mode.pl';
require 'scripts\\c_1_fork.pl';
require 'scripts\\c_2_connect_get_id.pl';
