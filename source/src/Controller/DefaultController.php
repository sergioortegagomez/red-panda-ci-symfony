<?php 

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use App\Entity\Product;

class DefaultController extends Controller
{
    public function index()
    {
        return new Response(
            '<html><body>Hello World</body></html>'
        );
    }

    public function insertDB(Request $resquest, $count)
    {
        $em = $this->getDoctrine()->getManager();
        for ($i = 1; $i<= $count; $i++) {
            $product = new Product();
            $product->name = "Product ".$i;
            $product->price = ($i/100) * rand(1, 100);
            $em->persist($product);
        }
        $em->flush();        
        return new Response(
            '<html><body>'.$count.' inserted</body></html>'
        );
    }
}