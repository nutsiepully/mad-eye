
include rvm

rvm::system_user { vagrant: ; }

rvm_system_ruby {
    'ruby-1.9.3-p286':
        ensure => 'present',
        default_use => true;
}

