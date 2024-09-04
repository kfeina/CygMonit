#!/usr/bin/env bash

set -e

monit_ssl_dir="/tmp"
now=$(date +%Y%m%d%H%M%S)
cert_cn="127.0.0.1"
cert_o="MyCompany Ltd."
cert_l="USA"
cert_c="EN"

openssl_bin=`which openssl`

${openssl_bin} req -new -x509 -sha256 -days 3650 -nodes -config "${monit_ssl_dir}/monitCertificate.cnf" -out "${monit_ssl_dir}/monit.pem" -keyout "${monit_ssl_dir}/monit.pem" -subj "/C=${cert_c}/L=${cert_l}/O=${cert_o}/CN=${cert_cn}"
${openssl_bin} gendh 512 >> "${monit_ssl_dir}/monit.pem"
${openssl_bin} x509 -subject -dates -fingerprint -noout -in "${monit_ssl_dir}/monit.pem"

echo "Monit SSL certificate info:"

${openssl_bin} x509 -in ${monit_ssl_dir}/monit.pem -noout -text -purpose
