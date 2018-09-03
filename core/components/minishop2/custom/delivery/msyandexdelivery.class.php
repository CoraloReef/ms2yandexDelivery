<?php
if(!class_exists('msDeliveryInterface')) {
    require_once dirname(dirname(dirname(__FILE__))) . '/model/minishop2/msdeliveryhandler.class.php';
}

class msYandexDelivery extends msDeliveryHandler implements msDeliveryInterface{

    public function getCost(msOrderInterface $order, msDelivery $delivery, $cost = 0) {

        $delivery_cost = parent::getCost($order, $delivery, $cost);
        return $delivery_cost += $_POST['delCostValue'];
    }
}
