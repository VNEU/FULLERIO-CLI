#!/bin/bash
LOKASINIPUN=$PWD
VERSION="0.0.1"
CODENAME="cobicobi"

echo "                     _/_/            _/  _/ "
echo "                  _/      _/    _/  _/  _/    _/_/    _/  _/_/ "
echo "               _/_/_/_/  _/    _/  _/  _/  _/_/_/_/  _/_/ "
echo "                _/      _/    _/  _/  _/  _/        _/ "
echo "               _/        _/_/_/  _/  _/    _/_/_/  _/ "
echo " "


if [ "$1" == "--version" ]; then
        echo "FLEXURIO Version $VERSION - $CODENAME";
elif [ "$1" == "-v" ]; then
        echo "FLEXURIO Version $VERSION - $CODENAME";
elif [ "$1" == "create" ]; then
        echo "FLEXURIO Version $VERSION - $CODENAME";
elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "Fuller is bootstraping graphql. "
    echo "Please read this options carefully. Any question feel free to email us at nunung.pamungkas@vneu.co.id. "
    echo "Please visit https://fullerio.com to join our community,  Mature Nuwun, GBU, Jayalah Indonesia "
    echo "  "
    echo "--version / -v                              Version of Flexurio"
    echo "--help / -h                                 help / tutorial usage"
    echo ""
    echo "create                                      create new fuller graphql"
    echo "newmodule                                   create service table fuller"
elif [ "$1" == "create" ]; then
    if [[ $2 = "" ]]; then
        echo " Please input project name "
    else
        if [ -d "$2" ]; then
            echo " Destination folder $2 already exists"
        else
            mkdir $2
            git clone https://github.com/VNEU/FULLER.git $2
            sudo rm -R $2/.git
            cd $2 && npm install
            echo " ----------------------------------------------------------------------------------------- "
            echo " CREATE PROCESS DONE. "
            echo "      *. Run fuller with 'node src/index.js', "
            echo "      *. After a while please visit http://localhost:3021 "
            echo "      *. Happy code with fuller guys, :) "
            echo " ----------------------------------------------------------------------------------------- "
        fi
    fi
elif [ "$1" == "newmodule" ]; then
    echo "Creating new fuller module . . . "
    if [[ $2 = "" ]]; then
        echo " Please input table name "
    else
        sTable_UPPERCASE=$(echo $2 | tr 'a-z' 'A-Z')
        sTable_LOWERCASE=$(echo $2 | tr '[:upper:]' '[:lower:]')

        sRESOLVER=$"
            const defaults = require('../defaults');
            const pubsub = require('../pubsub');
            let object = {
                id: function (root) {
                    return root._id || root.id;
                },
            };
            let query = async function (root, data, {user, conMongo:{$sTable_UPPERCASE}}) {
                data = defaults.queryKolom(data, user);
                return await $sTable_UPPERCASE.find(data).toArray();
            };
            let mutasi_create = async function (root, data, {user, conMongo:{$sTable_UPPERCASE}}) {
                data = defaults.createKolom(data, user);
                const response = await $sTable_UPPERCASE.insert(data);
                data = Object.assign({id: response.insertedIds[0]}, data);
                pubsub.publish('$sTable_UPPERCASE', {$sTable_UPPERCASE: {mutation: 'CREATED', node: data}});
                return data;
            };
            let mutasi_update = async function (root, data, {user, conMongo:{$sTable_UPPERCASE}}) {
                data = defaults.createKolom(data, user);
                let dataLama = await $sTable_UPPERCASE.findOne({_id: data._id});
                let dataBaru = Object.assign(dataLama, data);
                await $sTable_UPPERCASE.update({_id: data._id}, dataBaru);
                return Object.assign({id: data._id}, dataBaru);
            };

            let subscribtion = {
                subscribe: function () {
                    return pubsub.asyncIterator('$sTable_UPPERCASE');
                },
            };

            exports.query = query;
            exports.object = object;
            exports.mutasi_create = mutasi_create;
            exports.mutasi_update = mutasi_update;
            exports.subscribtion = subscribtion;
        "
        echo "$sRESOLVER" >  "src/schema/resolvers/items/$sTable_LOWERCASE.js"

        sed -i "s/const pubsub = require('.\\/pubsub');/const pubsub = require('.\\/pubsub');\nlet $sTable_LOWERCASE = require('.\\/items\\/$sTable_LOWERCASE');/g" src/schema/resolvers/resolver.js
        sed -i "s/let Query = {};/let Query = {};\nQuery.$sTable_UPPERCASE = $sTable_LOWERCASE.query;/g" src/schema/resolvers/resolver.js
        sed -i "s/let Mutation = {};/let Mutation = {};\nMutation.update$sTable_UPPERCASE = $sTable_LOWERCASE.mutasi_update;/g" src/schema/resolvers/resolver.js
        sed -i "s/let Resolver = {};/let Resolver = {};\nResolver.$sTable_UPPERCASE = $sTable_LOWERCASE.object;/g" src/schema/resolvers/resolver.js
        sed -i "s/let Subscribtion = {};/let Subscribtion = {};\nSubscribtion.$sTable_UPPERCASE = $sTable_LOWERCASE.subscribtion;/g" src/schema/resolvers/resolver.js



        sSCHEMA=$"
            let object = \`
                type $sTable_UPPERCASE {
                    id: ID!,
                    // Add your fields here
                }
            \`;

            let query = \`
                $sTable_UPPERCASE(
                    id: ID!,
                    // Add your fields here
                ): [$sTable_UPPERCASE!]!
            \`;

            let mutation_create = \`
                create$sTable_UPPERCASE(
                    // Add your fields here
                ): $sTable_UPPERCASE
            \`;

            let mutation_update = \`
                update$sTable_UPPERCASE(
                    id: ID!,
                    // Add your fields here
                ): $sTable_UPPERCASE
            \`;

            let subscribtion = \`
                  $sTable_UPPERCASE(filter: Filter$sTable_UPPERCASE): Payload$sTable_UPPERCASE
            \`;

            let subscribtion_filter_payload = \`
                input Filter$sTable_UPPERCASE {
                  mutation_in: [_ModelMutationType!]
                }

                type Payload$sTable_UPPERCASE {
                  mutation: _ModelMutationType!
                  node: $sTable_UPPERCASE
                } \`;

            exports.query = query;
            exports.object = object;
            exports.mutation_create = mutation_create;
            exports.mutation_update = mutation_update;
            exports.subscribtion = subscribtion;
            exports.subscribtion_filter_payload = subscribtion_filter_payload;
        "

        echo "$sSCHEMA" >  "src/schema/types/items/$sTable_LOWERCASE.js"
        sed -i "s/var user = require('.\\/items\\/user');/var user = require('.\\/items\\/user');\nconst $sTable_LOWERCASE = require('.\\/items\\/$sTable_LOWERCASE');/g" src/schema/types/type.js
        sed -i "s/let Mutation =/let Mutation =\n$sTable_LOWERCASE.mutation_update +/g" src/schema/types/type.js
        sed -i "s/let Objects =/let Objects =\n$sTable_LOWERCASE.object +/g" src/schema/types/type.js
        sed -i "s/let Query =/let Query =\n$sTable_LOWERCASE.query +/g" src/schema/types/type.js
        sed -i "s/let Subscribtion = \`type Subscription { \` +/let Subscribtion = \`type Subscription { \` +\n$sTable_LOWERCASE.subscribtion +/g" src/schema/types/type.js
        sed -i "s/let Subscribtion_FilterPayload = \` enum _ModelMutationType { CREATED UPDATED DELETED }\`/let Subscribtion_FilterPayload = \` enum _ModelMutationType { CREATED UPDATED DELETED }\`\n+ $sTable_LOWERCASE.subscribtion_filter_payload/g" src/schema/types/type.js


        sed -i "s/let database = {};/let database = {};\ndatabase.$sTable_UPPERCASE = db.collection('$sTable_LOWERCASE');/g" src/connections/connection_mongo.js

    fi
fi