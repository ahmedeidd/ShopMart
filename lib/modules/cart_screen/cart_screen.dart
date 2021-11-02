import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/models/cartModels/cartModel.dart';
import 'package:matjar_app/modules/product_screen/product_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:matjar_app/shard/components/constants.dart';
import 'package:sizer/sizer.dart';

TextEditingController counterController = TextEditingController();

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var shopcub = ShopCubit.get(context);
        CartModel cartModel = shopcub.cartModel;
        cartLength = shopcub.cartModel.data!.cartItems.length;
        return shopcub.cartModel.data!.cartItems.length == 0
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 70,
                        color: Colors.greenAccent,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AutoSizeText(
                        getTranslated(context, "Your_Cart_is_empty")!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => cartProducts(
                        shopcub.cartModel.data!.cartItems[index],
                        context,
                      ),
                      separatorBuilder: (context, index) => myDivider(),
                      itemCount: cartLength,
                    ),
                    Container(
                      color: Colors.grey[200],
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 1.0.h,
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                getTranslated(
                                      context,
                                      "Subtotal_key",
                                    )! +
                                    "($cartLength ${getTranslated(context, 'items_key')})",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Spacer(),
                              AutoSizeText(
                                getTranslated(
                                      context,
                                      "LE_key",
                                    )! +
                                    '${cartModel.data!.subTotal}',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.0.h,
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                getTranslated(
                                  context,
                                  "Shipping_Fee",
                                )!,
                              ),
                              Spacer(),
                              AutoSizeText(
                                getTranslated(
                                  context,
                                  "Free_key",
                                )!,
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 1.0.h,
                          ),
                          Row(
                            textBaseline: TextBaseline.alphabetic,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                              AutoSizeText(
                                getTranslated(
                                  context,
                                  "TOTAL_key",
                                )!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              AutoSizeText(
                                getTranslated(
                                  context,
                                  "Inclusive_of_VAT",
                                )!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Spacer(),
                              AutoSizeText(
                                getTranslated(
                                      context,
                                      "LE_key",
                                    )! +
                                    '${cartModel.data!.total}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.0.h,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 10.0.h,
                      color: Colors.white,
                    ),
                  ],
                ),
              );
      },
    );
  }

  //****************************************************************************
  Widget cartProducts(CartItems? model, context) {
    counterController.text = '${model!.quantity}';
    return InkWell(
      onTap: () {
        ShopCubit.get(context).getProductData(model.product!.id);
        navigateTo(context, ProductScreen());
      },
      child: Container(
        height: 31.h,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: [
            Image(
              image: NetworkImage('${model.product!.image}'),
              width: 150,
              height: 150,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    model.product!.name.toString(),
                    minFontSize: 10,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  AutoSizeText(
                    getTranslated(context, "LE_key")! +
                        model.product!.price.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                    minFontSize: 10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (model.product!.discount != 0)
                    AutoSizeText(
                      getTranslated(context, "LE_key")! +
                          model.product!.oldPrice.toString(),
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 11.sp,
                      ),
                      minFontSize: 10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        child: MaterialButton(
                          minWidth: 20,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            int quantity = model.quantity! - 1;
                            if (quantity != 0)
                              ShopCubit.get(context).updateCartData(
                                model.id,
                                quantity,
                              );
                          },
                          child: Icon(
                            Icons.remove,
                            size: 17,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      AutoSizeText(
                        '${model.quantity}',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        child: MaterialButton(
                          minWidth: 10,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            int quantity = model.quantity! + 1;
                            if (quantity <= 5)
                              ShopCubit.get(context).updateCartData(
                                model.id,
                                quantity,
                              );
                          },
                          child: Icon(
                            Icons.add,
                            size: 17,
                            color: Colors.green[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      ShopCubit.get(context).addToCart(model.product!.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        SizedBox(
                          width: 2.5,
                        ),
                        AutoSizeText(
                          getTranslated(context, "Remove_key")!,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
