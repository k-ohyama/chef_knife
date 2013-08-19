# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

[ -f /etc/profile ] && source /etc/profile
export PATH=$PATH:/usr/pgsql-9.2/bin
export POSTGRES_HOME=/usr/pgsql-9.2
export PGDATA=/var/lib/pgsql/9.2/data
export MANPATH="$MANPATH":$POSTGRES_HOME/share/man
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH":"$PGLIB"
