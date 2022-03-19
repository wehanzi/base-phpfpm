#!/usr/bin/env sh

# Configure XDebug
XDEBUG_INI=/usr/local/etc/php/conf.d/xdebug.ini

if echo "$XDEBUG_MODE" | grep -q "debug" || echo "${XDEBUG_MODE}" | grep -q "coverage" ; then
    # Configure XDEBUG extension and configuration
    echo "Enabling XDebug Configuration"
    # we use tilde ~ here instead of / because of path names
    sed -i "s~__XDEBUG_IDE_KEY__~${XDEBUG_IDE_KEY}~g" ${XDEBUG_INI}
    sed -i "s~__XDEBUG_MODE__~${XDEBUG_MODE}~g" ${XDEBUG_INI}
    sed -i "s~__XDEBUG_HOST__~${XDEBUG_HOST}~g" ${XDEBUG_INI}
    sed -i "s~__XDEBUG_PORT__~${XDEBUG_PORT}~g" ${XDEBUG_INI}
    sed -i "s~__XDEBUG_LOG_DIR__~${XDEBUG_LOG_DIR}~g" ${XDEBUG_INI}
    sed -i "s~__XDEBUG_OUTPUT_DIR__~${XDEBUG_LOG_DIR}~g" ${XDEBUG_INI}

	if [ ! -d "${XDEBUG_LOG_DIR}" ]; then
		mkdir ${XDEBUG_LOG_DIR}
		chmod 755 ${XDEBUG_LOG_DIR}
		chown www-data:www-data ${XDEBUG_LOG_DIR}
	fi
    echo "" > ${XDEBUG_LOG_DIR}/xdebug.log
else
    echo "Disabling XDebug Configuration"
    rm -f ${XDEBUG_INI}
    rm -f ${XDEBUG_LOG_DIR}/xdebug.log
fi
