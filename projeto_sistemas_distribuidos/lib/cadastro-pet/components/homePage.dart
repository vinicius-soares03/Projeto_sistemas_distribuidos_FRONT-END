import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projeto_sistemas_distribuidos/API/service.dart';
import 'package:projeto_sistemas_distribuidos/cadastro-pet/bloc/cadastro-pet-cubit-model.dart';
import 'package:projeto_sistemas_distribuidos/cadastro-pet/bloc/cadastro-pet-cubit.dart';
import 'package:projeto_sistemas_distribuidos/cadastro-pet/components/cadastro-pet-form.dart';
import 'package:projeto_sistemas_distribuidos/cadastro-pet/components/detalhePet.dart';
import 'package:projeto_sistemas_distribuidos/cadastro-pet/components/inbox.dart';
import 'package:projeto_sistemas_distribuidos/cadastro-pet/models/Pet-retornoAPI.dart';
import 'package:projeto_sistemas_distribuidos/cadastro-pet/models/Pet.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static String ROUTE = "/home-page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CadastroPetCubit? _bloc;

  @override
  Widget build(BuildContext context) {
    return new BlocProvider(
      create: (BuildContext context) {
        _bloc = CadastroPetCubit();
        _bloc!.inicializarListaPets();
        return _bloc!;
      },
      child: new BlocBuilder<CadastroPetCubit, CadastroPetModel>(
        builder: (context, state) {
          return new Scaffold(
            appBar: new PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: _buildAppBar(),
            ),
            drawer: _buildDrawer(),
            extendBodyBehindAppBar: false,
            body: _buildBody(),
            floatingActionButton: Container(
              alignment: Alignment.bottomRight,
              child: new FloatingActionButton(
                backgroundColor: Color.fromRGBO(96, 80, 136, 1),
                onPressed: () {
                  
                  Navigator.of(context)
                      .pushNamed(CadastroPet.ROUTE, arguments: _bloc);
                },
                child: new Icon(Icons.add, size: 28),
                elevation: 1,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<CadastroPetCubit, CadastroPetModel>(
      builder: (context, state) {
        if (state.listaPets!.isNotEmpty) {
          return _buildGridViewPets(state.listaPets);
        } else {
          return new Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 32, right: 32),
            width: MediaQuery.of(context).size.width,
            child: new Text(
              "Atualmente, não possuimos nenhum animal disponível para adoção.",
              textAlign: TextAlign.center,
              style: new TextStyle(
                  height: 1.5, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          );
        }
      },
    );
  }

  Widget _buildGridViewPets(List<PetRetonoAPI>? listaPets) {
    return new SingleChildScrollView(
      child: new Column(
        children: [
          _buildBarraPesquisa(),
          new Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.2,
              padding: const EdgeInsets.only(top: 20, bottom: 8),
              child: new GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 20,
                      crossAxisCount: 2,
                      mainAxisExtent: 260),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  itemCount: listaPets?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new GestureDetector(
                      onTap: () {
                        _bloc!.petSelecionado = listaPets![index];

                        Navigator.pushNamed(context, DetalhePet.ROUTE,
                            arguments: _bloc);
                      },
                      child: new Container(
                        padding: const EdgeInsets.only(bottom: 4),
                        decoration: new BoxDecoration(
                          color: const Color.fromRGBO(243, 241, 237, 1),
                          borderRadius: new BorderRadius.circular(12),
                        ),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            new ClipRRect(
                              borderRadius: new BorderRadius.only(
                                  topLeft: new Radius.circular(12),
                                  topRight: new Radius.circular(12)),
                              child: listaPets![index].imagem != null
                                  ? new Image.memory(
                                      listaPets[index].imagem!,
                                      height: 140,
                                      width: 175,
                                      fit: BoxFit.cover,
                                    )
                                  : new Container(),
                            ),
                            new Container(
                                padding: const EdgeInsets.only(top: 4),
                                alignment: Alignment.bottomCenter,
                                child: new Text(
                                  "${listaPets[index].nome}",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            new Divider(),
                            _retornaDescricaoPetGridview(
                                Icons.eighteen_mp_outlined,
                                "${listaPets[index].idade}"),
                            _retornaDescricaoPetGridview(Icons.pets_outlined,
                                "${listaPets[index].raca}"),
                            _retornaDescricaoPetGridview(
                                Icons.fmd_good_outlined,
                                "${listaPets[index].localizacao}"),
                          ],
                        ),
                      ),
                    );
                  })),
        ],
      ),
    );
  }

  Widget _retornaDescricaoPetGridview(IconData icon, String descricao) {
    return new Container(
        padding: const EdgeInsets.only(left: 8),
        child: new Row(
          children: [
            new Icon(
              icon,
              color: const Color.fromRGBO(96, 80, 136, 1),
              size: 20,
            ),
            new Container(
              padding: const EdgeInsets.only(left: 8),
              child: new Text(
                descricao,
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
  }

  Widget _buildBarraPesquisa() {
    return new Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height / 20,
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.black, width: 1.2),
        borderRadius: new BorderRadius.circular(8),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Container(
            padding: const EdgeInsets.only(left: 16),
            child: new Text('O que está buscando?'),
          ),
          new Container(
              padding: const EdgeInsets.only(right: 16),
              child: new Icon(Icons.search)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return new AppBar(
      leading: new Builder(
        builder: (context) => new IconButton(
          icon: new Icon(
            Icons.menu,
            size: 32,
            color: const Color.fromRGBO(96, 80, 136, 1),
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      backgroundColor: Colors.white,
      title: new Text(
        'OLX DE DOGUINHO',
        style: new TextStyle(
          color: const Color.fromRGBO(96, 80, 136, 1),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        new GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(Inbox.ROUTE, arguments: _bloc);
          },
          child: new Container(
            padding: const EdgeInsets.only(right: 16),
            child: new Icon(
              Icons.inbox,
              size: 32,
              color: const Color.fromRGBO(96, 80, 136, 1),
            ),
          ),
        )
      ],
    );
  }

  _buildDrawer() {
    return new Drawer(
      backgroundColor: Color.fromRGBO(96, 80, 136, 1),
      child: new ListView(
        children: [
          new DrawerHeader(
            child: new Center(
              child: new Column(
                children: [
                  new Image.asset(
                    "assets/logo.png",
                    scale: 1.8,
                  ),
                  new Text(
                    'OLX DE DOGUINHO',
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Divider(color: Color.fromRGBO(243, 241, 237, 1)),
          new ListTile(
            leading: new Icon(
              Icons.pets_outlined,
              color: Colors.white,
            ),
            title: new GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(CadastroPet.ROUTE, arguments: _bloc!);
              },
              child: new Text(
                "Cadastre seu PET",
                style: new TextStyle(color: Color.fromRGBO(243, 241, 237, 1)),
              ),
            ),
            style: ListTileStyle.drawer,
          ),
          new Divider(color: Color.fromRGBO(243, 241, 237, 1)),
          new ListTile(
            leading: Icon(
              Icons.info_outlined,
              color: Colors.white,
            ),
            title: new GestureDetector(
              child: new Text("Sobre Nós",
                  style:
                      new TextStyle(color: Color.fromRGBO(243, 241, 237, 1))),
            ),
            style: ListTileStyle.drawer,
          ),
          new Divider(color: Color.fromRGBO(243, 241, 237, 1)),
          new ListTile(
            leading: new Icon(
              Icons.settings,
              color: Colors.white,
            ),
            title: new GestureDetector(
              child: new Text("Configurações",
                  style:
                      new TextStyle(color: Color.fromRGBO(243, 241, 237, 1))),
            ),
            style: ListTileStyle.drawer,
          ),
        ],
      ),
    );
  }
}
