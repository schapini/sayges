echo "Descargando la version de vub.war" 
wget "$1" -O vub.war.nuevo

echo "copiando vub.war a directorio respaldo aguarde un instante"

cp /root/actualizar/vub.war.nuevo /root/actualizar/ultimoWar/
sleep 5



###########################################
echo "Iniciando edición de war." 

unzip vub.war.nuevo index.zul login.zul
sed 's/<?page title=".*"?>/<?page title="GENExpedientes"?>/g' index.zul  > index.zul-2
mv index.zul-2 index.zul
sed 's/<?page title=".*"?>/<?page title="GENExpedientes"?>/g' login.zul  > login.zul-2
mv login.zul-2 login.zul

fecha=`date +%Y%m%d-%H%M%S`
sed 's/<label style="color: #fff; font-size: 10px;" value="Propiedad intelectual.*"\/>/<label style="color: transparent; font-size: 10px;" value="'"${fecha}"'"\/>/g' login.zul > login.zul-2
mv login.zul-2 login.zul
sed 's/<div class="animated fadeInDown" align="center" style="position: fixed;top:0">/<div class="animated fadeInDown" align="center" style="position: fixed;bottom:0;right:0;">/g' login.zul > login.zul-2
mv login.zul-2 login.zul

mkdir -p img/open/
cp logo-1.png logo-2.png fondo.jpg img/open/
zip vub.war.nuevo index.zul login.zul /img/open/*
rm index.zul login.zul img -rf

echo "Edición de war terminada." 

##############################################

echo "actualizando en el servidor" 
cd /opt/sayges
#sh stop-bonita.sh
su sayges -c "sh stop-bonita.sh"
rm -fr server/webapps/vub
mv server/webapps/vub.war /root/actualizar/vub.war.backup.$(date +%Y%m%d-%s)
mv /root/actualizar/vub.war.nuevo server/webapps/vub.war
#/etc/init.d/mysql restart
su sayges -c "sh star-bonita.sh"
#sleep 20

#sh start-bonita.sh

echo "Actualizacion Finalizada" 

###############################################
