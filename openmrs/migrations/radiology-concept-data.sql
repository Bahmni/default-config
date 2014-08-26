set @concept_id = 0;
set @answer_concept_id = 0;
set @concept_name_short_id = 0;
set @concept_name_full_id = 0;
select concept_id INTO @other_investigations_concept_id from concept_name where name='Other Investigations' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0;

select concept_id INTO @other_investigations_categories_concept_id from concept_name where name='Other Investigations Categories' and concept_name_type = 'FULLY_SPECIFIED' and voided = 0;


--  Row 0 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Radiology', 'radiology', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'RADIOLOGY', 1);
set @investigation_0333e700220b8a5b1dace16b34380773 = @concept_id;
call add_concept_set_members(@other_investigations_concept_id,@investigation_0333e700220b8a5b1dace16b34380773,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Chest', 'chest', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CHEST', 1);
set @category_826b87e8826239260b38566579f735c3 = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_826b87e8826239260b38566579f735c3,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Chest, 1 view (X-ray)', 'chest, 1 view (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CHEST,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '1', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEW', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_a05fa9effbd9e4eb4d75a4edeeb1bccd = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_a05fa9effbd9e4eb4d75a4edeeb1bccd,1);
call add_concept_set_members(@category_826b87e8826239260b38566579f735c3,@test_a05fa9effbd9e4eb4d75a4edeeb1bccd,1);

--  Row 1 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Spine', 'spine', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPINE', 1);
set @category_f7ddf75687b851effa874c136a95708d = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_f7ddf75687b851effa874c136a95708d,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Spine, 1 view (X-ray)', 'spine, 1 view (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPINE,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '1', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEW', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_e45508ce688e3819918008574d8697d8 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_e45508ce688e3819918008574d8697d8,1);
call add_concept_set_members(@category_f7ddf75687b851effa874c136a95708d,@test_e45508ce688e3819918008574d8697d8,1);

--  Row 2 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Pelvis', 'pelvis', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'PELVIS', 1);
set @category_bf5a8a90c1d557c7325604dfd0838761 = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_bf5a8a90c1d557c7325604dfd0838761,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Pelvis, 1 view (X-ray)', 'pelvis, 1 view (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'PELVIS,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '1', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEW', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_75705f017ea84333cb7ee68ffea18a71 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_75705f017ea84333cb7ee68ffea18a71,1);
call add_concept_set_members(@category_bf5a8a90c1d557c7325604dfd0838761,@test_75705f017ea84333cb7ee68ffea18a71,1);

--  Row 3 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Abdomen', 'abdomen', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ABDOMEN', 1);
set @category_69cdbed97f594ce133240fedaf38b13d = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_69cdbed97f594ce133240fedaf38b13d,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Abdomen, 1 view (X-ray)', 'abdomen, 1 view (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ABDOMEN,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '1', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEW', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_8bd8b404656363cacc88d2c30a516b2e = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_8bd8b404656363cacc88d2c30a516b2e,1);
call add_concept_set_members(@category_69cdbed97f594ce133240fedaf38b13d,@test_8bd8b404656363cacc88d2c30a516b2e,1);

--  Row 4 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Knee', 'knee', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'KNEE', 1);
set @category_07b866bbb3638ddc14f5949a2805a210 = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_07b866bbb3638ddc14f5949a2805a210,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Knee - Left, 1 or 2 views (X-ray)', 'knee - left, 1 or 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'KNEE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '1', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'OR', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_490c4b94334b89589f4ecc544a31f98d = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_490c4b94334b89589f4ecc544a31f98d,1);
call add_concept_set_members(@category_07b866bbb3638ddc14f5949a2805a210,@test_490c4b94334b89589f4ecc544a31f98d,1);

--  Row 5 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Knee - Right, 1 or 2 views (X-ray)', 'knee - right, 1 or 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'KNEE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '1', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'OR', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_77f77a00c9e69e6ee4295cbf3e654d2a = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_77f77a00c9e69e6ee4295cbf3e654d2a,1);
call add_concept_set_members(@category_07b866bbb3638ddc14f5949a2805a210,@test_77f77a00c9e69e6ee4295cbf3e654d2a,1);

--  Row 6 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Chest, 2 views (X-ray)', 'chest, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CHEST,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_eff8d7ea1374f077e30ee27cd43debb6 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_eff8d7ea1374f077e30ee27cd43debb6,1);
call add_concept_set_members(@category_826b87e8826239260b38566579f735c3,@test_eff8d7ea1374f077e30ee27cd43debb6,1);

--  Row 7 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Hip', 'hip', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HIP', 1);
set @category_b2fccee954cbaad734909ccbb0d4d900 = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_b2fccee954cbaad734909ccbb0d4d900,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Hip - Left, 2 views (X-ray)', 'hip - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HIP', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_b25271d1158680d0f29484bf816c4360 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_b25271d1158680d0f29484bf816c4360,1);
call add_concept_set_members(@category_b2fccee954cbaad734909ccbb0d4d900,@test_b25271d1158680d0f29484bf816c4360,1);

--  Row 8 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Hand', 'hand', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HAND', 1);
set @category_ac11ab7b292d5e9bd04a7d80898aee2b = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_ac11ab7b292d5e9bd04a7d80898aee2b,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Hand - Left, 2 views (X-ray)', 'hand - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HAND', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_d97f6cb9421d15ef006effcad1ea9445 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_d97f6cb9421d15ef006effcad1ea9445,1);
call add_concept_set_members(@category_ac11ab7b292d5e9bd04a7d80898aee2b,@test_d97f6cb9421d15ef006effcad1ea9445,1);

--  Row 9 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Hip - Right, 2 views (X-ray)', 'hip - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HIP', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_39f827d0967fe0086be9f5ab914c8659 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_39f827d0967fe0086be9f5ab914c8659,1);
call add_concept_set_members(@category_b2fccee954cbaad734909ccbb0d4d900,@test_39f827d0967fe0086be9f5ab914c8659,1);

--  Row 10 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Ribs', 'ribs', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIBS', 1);
set @category_3dc29d70c768969d17c01111643061df = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_3dc29d70c768969d17c01111643061df,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Ribs - Left, 2 views (X-ray)', 'ribs - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIBS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_ec096a995011d26e137b73bee2fa6963 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_ec096a995011d26e137b73bee2fa6963,1);
call add_concept_set_members(@category_3dc29d70c768969d17c01111643061df,@test_ec096a995011d26e137b73bee2fa6963,1);

--  Row 11 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Leg', 'leg', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
set @category_4eeb220fb7213c3543a080735be8dbe3 = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_4eeb220fb7213c3543a080735be8dbe3,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Foot - Left, 2 views (X-ray)', 'foot - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'FOOT', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_51b6d4f6200b63ccac43018835237119 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_51b6d4f6200b63ccac43018835237119,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_51b6d4f6200b63ccac43018835237119,1);

--  Row 12 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Femur - Left, 2 views (X-ray)', 'femur - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'FEMUR', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_d3e1f4c245900ac9cce71e28539dae91 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_d3e1f4c245900ac9cce71e28539dae91,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_d3e1f4c245900ac9cce71e28539dae91,1);

--  Row 13 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Ribs - Right, 2 views (X-ray)', 'ribs - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIBS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_95b4d11a541a16d87c3ce0a363eb8979 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_95b4d11a541a16d87c3ce0a363eb8979,1);
call add_concept_set_members(@category_3dc29d70c768969d17c01111643061df,@test_95b4d11a541a16d87c3ce0a363eb8979,1);

--  Row 14 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Foot - Right, 2 views (X-ray)', 'foot - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'FOOT', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_e0c025cfc48f12afb15f8970c294e195 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_e0c025cfc48f12afb15f8970c294e195,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_e0c025cfc48f12afb15f8970c294e195,1);

--  Row 15 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Arm', 'arm', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
set @category_184e71c3fda19f0790fae7f71952de51 = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_184e71c3fda19f0790fae7f71952de51,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Elbow - Left, 2 views (X-ray)', 'elbow - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ELBOW', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_1d53523e3522511e12456ae08ee09cbc = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_1d53523e3522511e12456ae08ee09cbc,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_1d53523e3522511e12456ae08ee09cbc,1);

--  Row 16 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Hand - Right, 2 views (X-ray)', 'hand - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HAND', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_e1d9ae46f45614664fdcf590dcb53cf2 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_e1d9ae46f45614664fdcf590dcb53cf2,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_e1d9ae46f45614664fdcf590dcb53cf2,1);

--  Row 17 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Wrist - Left, 2 views (X-ray)', 'wrist - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'WRIST', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_bfab4b897764cccafca4a3a33ea3c703 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_bfab4b897764cccafca4a3a33ea3c703,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_bfab4b897764cccafca4a3a33ea3c703,1);

--  Row 18 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Elbow - Right, 2 views (X-ray)', 'elbow - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ELBOW', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_ed7a2e4a3fc09b316f1565a7126e961c = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_ed7a2e4a3fc09b316f1565a7126e961c,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_ed7a2e4a3fc09b316f1565a7126e961c,1);

--  Row 19 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Wrist - Right, 2 views (X-ray)', 'wrist - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'WRIST', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_dded2468d0a5936a981d59012e81b829 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_dded2468d0a5936a981d59012e81b829,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_dded2468d0a5936a981d59012e81b829,1);

--  Row 20 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Femur - Right, 2 views (X-ray)', 'femur - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'FEMUR', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_f92df8a5cf03811a149961b8093381a9 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_f92df8a5cf03811a149961b8093381a9,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_f92df8a5cf03811a149961b8093381a9,1);

--  Row 21 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Forearm - Left, 2 views (X-ray)', 'forearm - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'FOREARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_ea45ab3be7a3fc6b6ec7423e5aaa5aa7 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_ea45ab3be7a3fc6b6ec7423e5aaa5aa7,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_ea45ab3be7a3fc6b6ec7423e5aaa5aa7,1);

--  Row 22 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Humerus - Left, 2 views (X-ray)', 'humerus - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HUMERUS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_efd64a439be4bb3188f66c40d417a9c8 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_efd64a439be4bb3188f66c40d417a9c8,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_efd64a439be4bb3188f66c40d417a9c8,1);

--  Row 23 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Lumbar spine, 2 or 3 views (X-ray)', 'lumbar spine, 2 or 3 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LUMBAR', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPINE,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'OR', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '3', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_2c0cc798fbee4344ba467fd4979a4a70 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_2c0cc798fbee4344ba467fd4979a4a70,1);
call add_concept_set_members(@category_f7ddf75687b851effa874c136a95708d,@test_2c0cc798fbee4344ba467fd4979a4a70,1);

--  Row 24 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Forearm - Right, 2 views (X-ray)', 'forearm - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'FOREARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_065bada40fda3cd3b1c3c8905d763484 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_065bada40fda3cd3b1c3c8905d763484,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_065bada40fda3cd3b1c3c8905d763484,1);

--  Row 25 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Shoulder', 'shoulder', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SHOULDER', 1);
set @category_df434eaab480ae7f49807503d9502a5b = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_df434eaab480ae7f49807503d9502a5b,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Clavicle - Left, 2 views (X-ray)', 'clavicle - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CLAVICLE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_75681fc89ccdf956c0fff2c1f7154cfa = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_75681fc89ccdf956c0fff2c1f7154cfa,1);
call add_concept_set_members(@category_df434eaab480ae7f49807503d9502a5b,@test_75681fc89ccdf956c0fff2c1f7154cfa,1);

--  Row 26 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Humerus - Right, 2 views (X-ray)', 'humerus - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HUMERUS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_1b63782cc66e5f5fe3c5928f5ad9a3ee = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_1b63782cc66e5f5fe3c5928f5ad9a3ee,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_1b63782cc66e5f5fe3c5928f5ad9a3ee,1);

--  Row 27 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Shoulder - Left, 2 views (X-ray)', 'shoulder - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SHOULDER', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_fda923454874ce12364a139764c203c8 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_fda923454874ce12364a139764c203c8,1);
call add_concept_set_members(@category_df434eaab480ae7f49807503d9502a5b,@test_fda923454874ce12364a139764c203c8,1);

--  Row 28 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Shoulder - Right, 2 views (X-ray)', 'shoulder - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SHOULDER', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_32e0ec8042855a618cd0205071dbbd6f = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_32e0ec8042855a618cd0205071dbbd6f,1);
call add_concept_set_members(@category_df434eaab480ae7f49807503d9502a5b,@test_32e0ec8042855a618cd0205071dbbd6f,1);

--  Row 29 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Lower leg - Left, 2 views (X-ray)', 'lower leg - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LOWER', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_260ed0f1adac2130709f319e9eaef553 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_260ed0f1adac2130709f319e9eaef553,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_260ed0f1adac2130709f319e9eaef553,1);

--  Row 30 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Calcaneus - Left, 2 views (X-ray)', 'calcaneus - left, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CALCANEUS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_80fe302f23aa220c655d29ec7d667f51 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_80fe302f23aa220c655d29ec7d667f51,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_80fe302f23aa220c655d29ec7d667f51,1);

--  Row 31 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Thoracic spine, 2 views (X-ray)', 'thoracic spine, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'THORACIC', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPINE,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_76bb1cba7c686b972d6fc223ec1d6cec = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_76bb1cba7c686b972d6fc223ec1d6cec,1);
call add_concept_set_members(@category_f7ddf75687b851effa874c136a95708d,@test_76bb1cba7c686b972d6fc223ec1d6cec,1);

--  Row 32 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Clavicle - Right, 2 views (X-ray)', 'clavicle - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CLAVICLE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_867f43bc7fcfe3e72d354b3118eb8a19 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_867f43bc7fcfe3e72d354b3118eb8a19,1);
call add_concept_set_members(@category_df434eaab480ae7f49807503d9502a5b,@test_867f43bc7fcfe3e72d354b3118eb8a19,1);

--  Row 33 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Lower leg - Right, 2 views (X-ray)', 'lower leg - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LOWER', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_46803b556fc65169f950f6029b253214 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_46803b556fc65169f950f6029b253214,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_46803b556fc65169f950f6029b253214,1);

--  Row 34 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Calcaneus - Right, 2 views (X-ray)', 'calcaneus - right, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CALCANEUS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_5b53dcea237c534d31b0f069a2e03ee3 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_5b53dcea237c534d31b0f069a2e03ee3,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_5b53dcea237c534d31b0f069a2e03ee3,1);

--  Row 35 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Cervical spine, 2 or 3 views (X-ray)', 'cervical spine, 2 or 3 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CERVICAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPINE,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'OR', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '3', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_2a8e6d1699ffa04ec7d83ce245a7dbda = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_2a8e6d1699ffa04ec7d83ce245a7dbda,1);
call add_concept_set_members(@category_f7ddf75687b851effa874c136a95708d,@test_2a8e6d1699ffa04ec7d83ce245a7dbda,1);

--  Row 36 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Thoracic and lumbar spine, 2 views (X-ray)', 'thoracic and lumbar spine, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'THORACIC', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AND', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LUMBAR', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPINE,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_bc9cc1e255c1dfd9273b97afc2bda34c = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_bc9cc1e255c1dfd9273b97afc2bda34c,1);
call add_concept_set_members(@category_f7ddf75687b851effa874c136a95708d,@test_bc9cc1e255c1dfd9273b97afc2bda34c,1);

--  Row 37 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Face', 'face', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'FACE', 1);
set @category_99c25d5f42e33ddcf79766fef92f91ab = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_99c25d5f42e33ddcf79766fef92f91ab,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Sinuses, 3 views (X-ray)', 'sinuses, 3 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SINUSES,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '3', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_4083055b0d99d6af64a370c892f61dc9 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_4083055b0d99d6af64a370c892f61dc9,1);
call add_concept_set_members(@category_99c25d5f42e33ddcf79766fef92f91ab,@test_4083055b0d99d6af64a370c892f61dc9,1);

--  Row 38 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Facial bones, 3 views (X-ray)', 'facial bones, 3 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'FACIAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'BONES,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '3', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_c1705e5da2fb5e9d4b82b9439e37ae79 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_c1705e5da2fb5e9d4b82b9439e37ae79,1);
call add_concept_set_members(@category_99c25d5f42e33ddcf79766fef92f91ab,@test_c1705e5da2fb5e9d4b82b9439e37ae79,1);

--  Row 39 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Head', 'head', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HEAD', 1);
set @category_87e43f25dacfe6514ec7454b3ca1b675 = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_87e43f25dacfe6514ec7454b3ca1b675,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Skull, 4 views (X-ray)', 'skull, 4 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SKULL,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '4', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_e1b25065caf6cc3adeb5bba2fad3b230 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_e1b25065caf6cc3adeb5bba2fad3b230,1);
call add_concept_set_members(@category_87e43f25dacfe6514ec7454b3ca1b675,@test_e1b25065caf6cc3adeb5bba2fad3b230,1);

--  Row 40 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Chest, 4 views (X-ray)', 'chest, 4 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CHEST,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '4', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_c722e97d1ffd6f7148818edea82c74fb = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_c722e97d1ffd6f7148818edea82c74fb,1);
call add_concept_set_members(@category_826b87e8826239260b38566579f735c3,@test_c722e97d1ffd6f7148818edea82c74fb,1);

--  Row 41 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Mandible panorex (X-ray) ', 'mandible panorex (x-ray) ', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'MANDIBLE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'PANOREX', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_aae7c0efa6f72b6800df74469875b252 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_aae7c0efa6f72b6800df74469875b252,1);
call add_concept_set_members(@category_99c25d5f42e33ddcf79766fef92f91ab,@test_aae7c0efa6f72b6800df74469875b252,1);

--  Row 42 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Chest lordotic (X-ray) ', 'chest lordotic (x-ray) ', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CHEST', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LORDOTIC', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_4f95b76eaa5b5e2d9596df414ba03403 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_4f95b76eaa5b5e2d9596df414ba03403,1);
call add_concept_set_members(@category_826b87e8826239260b38566579f735c3,@test_4f95b76eaa5b5e2d9596df414ba03403,1);

--  Row 43 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Chest oblique - Bilateral (X-ray) ', 'chest oblique - bilateral (x-ray) ', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CHEST', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'OBLIQUE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'BILATERAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_f256e46100b9b4c443a5b7cd3a52d1d2 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_f256e46100b9b4c443a5b7cd3a52d1d2,1);
call add_concept_set_members(@category_826b87e8826239260b38566579f735c3,@test_f256e46100b9b4c443a5b7cd3a52d1d2,1);

--  Row 44 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Other', 'other', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'OTHER', 1);
set @category_dd9d5ba28690c78f7dac5a4aba986edb = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_dd9d5ba28690c78f7dac5a4aba986edb,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Kidney retrograde pyelogram (X-ray) ', 'kidney retrograde pyelogram (x-ray) ', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'KIDNEY', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RETROGRADE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'PYELOGRAM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_b0a032624d556fe72bed98971861fb67 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_b0a032624d556fe72bed98971861fb67,1);
call add_concept_set_members(@category_dd9d5ba28690c78f7dac5a4aba986edb,@test_b0a032624d556fe72bed98971861fb67,1);

--  Row 45 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Acromioclavicular joints - Bilateral (X-ray) ', 'acromioclavicular joints - bilateral (x-ray) ', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ACROMIOCLAVICULAR', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'JOINTS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'BILATERAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_2208d541f61c2bfcf9b4c85ab7db71fe = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_2208d541f61c2bfcf9b4c85ab7db71fe,1);
call add_concept_set_members(@category_df434eaab480ae7f49807503d9502a5b,@test_2208d541f61c2bfcf9b4c85ab7db71fe,1);

--  Row 46 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Abdomen AP (supine and lateraldecubitus) (X-ray) ', 'abdomen ap (supine and lateraldecubitus) (x-ray) ', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ABDOMEN', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(SUPINE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AND', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERALDECUBITUS)', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_c80da74fab1f70909a038deb130dc7d1 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_c80da74fab1f70909a038deb130dc7d1,1);
call add_concept_set_members(@category_69cdbed97f594ce133240fedaf38b13d,@test_c80da74fab1f70909a038deb130dc7d1,1);

--  Row 47 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Ankle - Left, 3 views (X-ray)', 'ankle - left, 3 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ANKLE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEFT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '3', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_0902f8831d6eba074d74c856a3ee66e4 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_0902f8831d6eba074d74c856a3ee66e4,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_0902f8831d6eba074d74c856a3ee66e4,1);

--  Row 48 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Ankle - Right, 3 views (X-ray)', 'ankle - right, 3 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ANKLE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '-', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RIGHT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '3', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_962c049a3c386ea5a13b5725b4034e34 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_962c049a3c386ea5a13b5725b4034e34,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_962c049a3c386ea5a13b5725b4034e34,1);

--  Row 49 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Neck', 'neck', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'NECK', 1);
set @category_748e8e2d0c36d418d8199bd894f48012 = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_748e8e2d0c36d418d8199bd894f48012,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Neck soft tissue (X-ray)', 'neck soft tissue (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'NECK', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SOFT', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'TISSUE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_2d3bdef2a227b59922cdf22d1ff1b0ee = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_2d3bdef2a227b59922cdf22d1ff1b0ee,1);
call add_concept_set_members(@category_748e8e2d0c36d418d8199bd894f48012,@test_2d3bdef2a227b59922cdf22d1ff1b0ee,1);

--  Row 50 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Temporomandibular joint, bilateral (XRay)', 'temporomandibular joint, bilateral (xray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'TEMPOROMANDIBULAR', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'JOINT,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'BILATERAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(XRAY)', 1);
set @test_cd98fbe7467c0837bda1e733870ccfbc = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_cd98fbe7467c0837bda1e733870ccfbc,1);
call add_concept_set_members(@category_99c25d5f42e33ddcf79766fef92f91ab,@test_cd98fbe7467c0837bda1e733870ccfbc,1);

--  Row 51 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Skull, 2 views (X-ray)', 'skull, 2 views (x-ray)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SKULL,', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '2', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'VIEWS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(X-RAY)', 1);
set @test_0e2bfe88f3ddc34f3d323a4207a5f061 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_0e2bfe88f3ddc34f3d323a4207a5f061,1);
call add_concept_set_members(@category_87e43f25dacfe6514ec7454b3ca1b675,@test_0e2bfe88f3ddc34f3d323a4207a5f061,1);

--  Row 52 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Endoscopy', 'endoscopy', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ENDOSCOPY', 1);
set @investigation_7405789853a3db0b050aa1cf1505687b = @concept_id;
call add_concept_set_members(@other_investigations_concept_id,@investigation_7405789853a3db0b050aa1cf1505687b,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Advanced Procedure', 'advanced procedure', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ADVANCED', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'PROCEDURE', 1);
set @category_8eac7a7a0de75cf8b6f65c89b7ae2b3a = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_8eac7a7a0de75cf8b6f65c89b7ae2b3a,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Anoscopy', 'anoscopy', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ANOSCOPY', 1);
set @test_d46677e7f26bd26afca25a5aaf264c49 = @concept_id;
call add_concept_set_members(@investigation_7405789853a3db0b050aa1cf1505687b,@test_d46677e7f26bd26afca25a5aaf264c49,1);
call add_concept_set_members(@category_8eac7a7a0de75cf8b6f65c89b7ae2b3a,@test_d46677e7f26bd26afca25a5aaf264c49,1);

--  Row 53 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Bronchoscopy', 'bronchoscopy', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'BRONCHOSCOPY', 1);
set @test_5473ac3cbcf277bc20029e010862b239 = @concept_id;
call add_concept_set_members(@investigation_7405789853a3db0b050aa1cf1505687b,@test_5473ac3cbcf277bc20029e010862b239,1);
call add_concept_set_members(@category_8eac7a7a0de75cf8b6f65c89b7ae2b3a,@test_5473ac3cbcf277bc20029e010862b239,1);

--  Row 54 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Colonoscopy', 'colonoscopy', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'COLONOSCOPY', 1);
set @test_33eaa5e4a45f2c1581bd83d88fcc22c4 = @concept_id;
call add_concept_set_members(@investigation_7405789853a3db0b050aa1cf1505687b,@test_33eaa5e4a45f2c1581bd83d88fcc22c4,1);
call add_concept_set_members(@category_8eac7a7a0de75cf8b6f65c89b7ae2b3a,@test_33eaa5e4a45f2c1581bd83d88fcc22c4,1);

--  Row 55 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Cystoscopy', 'cystoscopy', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CYSTOSCOPY', 1);
set @test_47eb4687a18ea290502db64f8663a87d = @concept_id;
call add_concept_set_members(@investigation_7405789853a3db0b050aa1cf1505687b,@test_47eb4687a18ea290502db64f8663a87d,1);
call add_concept_set_members(@category_8eac7a7a0de75cf8b6f65c89b7ae2b3a,@test_47eb4687a18ea290502db64f8663a87d,1);

--  Row 56 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Normal Procedure', 'normal procedure', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'NORMAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'PROCEDURE', 1);
set @category_225a7ab098e616e4033ce08812306c5b = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_225a7ab098e616e4033ce08812306c5b,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Esophagogastroduodenoscopy (EGD)', 'esophagogastroduodenoscopy (egd)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ESOPHAGOGASTRODUODENOSCOPY', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(EGD)', 1);
set @test_d79bd9edb88f7aa0592bdaa44e888bc6 = @concept_id;
call add_concept_set_members(@investigation_7405789853a3db0b050aa1cf1505687b,@test_d79bd9edb88f7aa0592bdaa44e888bc6,1);
call add_concept_set_members(@category_225a7ab098e616e4033ce08812306c5b,@test_d79bd9edb88f7aa0592bdaa44e888bc6,1);

--  Row 57 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Enteroscopy', 'enteroscopy', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ENTEROSCOPY', 1);
set @test_79fa2e3267f1b26ee5a536f804bb66fc = @concept_id;
call add_concept_set_members(@investigation_7405789853a3db0b050aa1cf1505687b,@test_79fa2e3267f1b26ee5a536f804bb66fc,1);
call add_concept_set_members(@category_225a7ab098e616e4033ce08812306c5b,@test_79fa2e3267f1b26ee5a536f804bb66fc,1);

--  Row 58 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Endoscopic retrograde cholangiopancreatography (ERCP)', 'endoscopic retrograde cholangiopancreatography (ercp)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ENDOSCOPIC', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RETROGRADE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'CHOLANGIOPANCREATOGRAPHY', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(ERCP)', 1);
set @test_ef10cd8d7e8c9760f49b83fc45c96fe1 = @concept_id;
call add_concept_set_members(@investigation_7405789853a3db0b050aa1cf1505687b,@test_ef10cd8d7e8c9760f49b83fc45c96fe1,1);
call add_concept_set_members(@category_225a7ab098e616e4033ce08812306c5b,@test_ef10cd8d7e8c9760f49b83fc45c96fe1,1);

--  Row 59 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Laparoscopy', 'laparoscopy', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LAPAROSCOPY', 1);
set @test_835342dcc34ea69fd6c0c8e4e4938037 = @concept_id;
call add_concept_set_members(@investigation_7405789853a3db0b050aa1cf1505687b,@test_835342dcc34ea69fd6c0c8e4e4938037,1);
call add_concept_set_members(@category_225a7ab098e616e4033ce08812306c5b,@test_835342dcc34ea69fd6c0c8e4e4938037,1);

--  Row 60 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Sigmoidoscopy', 'sigmoidoscopy', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SIGMOIDOSCOPY', 1);
set @test_84fc9ec1ea4280b956f66a7c14b72fcc = @concept_id;
call add_concept_set_members(@investigation_7405789853a3db0b050aa1cf1505687b,@test_84fc9ec1ea4280b956f66a7c14b72fcc,1);
call add_concept_set_members(@category_225a7ab098e616e4033ce08812306c5b,@test_84fc9ec1ea4280b956f66a7c14b72fcc,1);

--  Row 61 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Clavicle AP', 'arm clavicle ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'CLAVICLE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_730db6f3572df7c248a014161d8ab1da = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_730db6f3572df7c248a014161d8ab1da,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_730db6f3572df7c248a014161d8ab1da,1);

--  Row 62 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Scapula AP', 'arm scapula ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SCAPULA', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_8d9660e5e0ced898c59c4d6974757c09 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_8d9660e5e0ced898c59c4d6974757c09,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_8d9660e5e0ced898c59c4d6974757c09,1);

--  Row 63 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Scapula Lateral', 'arm scapula lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SCAPULA', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_b64c7d020f2bcd56adcea4a560951e5e = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_b64c7d020f2bcd56adcea4a560951e5e,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_b64c7d020f2bcd56adcea4a560951e5e,1);

--  Row 64 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Shoulder AP', 'arm shoulder ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SHOULDER', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_c9cc4da8f5b87f489a60d8b5810cd0c5 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_c9cc4da8f5b87f489a60d8b5810cd0c5,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_c9cc4da8f5b87f489a60d8b5810cd0c5,1);

--  Row 65 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Shoulder Axial', 'arm shoulder axial', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SHOULDER', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AXIAL', 1);
set @test_e6c33dcf89b481cf6a111583d2321883 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_e6c33dcf89b481cf6a111583d2321883,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_e6c33dcf89b481cf6a111583d2321883,1);

--  Row 66 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Humerus AP', 'arm humerus ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'HUMERUS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_7b842f3583a07531193050e61b7f2a22 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_7b842f3583a07531193050e61b7f2a22,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_7b842f3583a07531193050e61b7f2a22,1);

--  Row 67 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Humerus Lateral', 'arm humerus lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'HUMERUS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_03f1b0247c483d9f047346b748b726e1 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_03f1b0247c483d9f047346b748b726e1,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_03f1b0247c483d9f047346b748b726e1,1);

--  Row 68 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Elbow AP', 'arm elbow ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'ELBOW', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_2d4d2f60383474809bb9eeca250407a5 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_2d4d2f60383474809bb9eeca250407a5,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_2d4d2f60383474809bb9eeca250407a5,1);

--  Row 69 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Elbow Lateral', 'arm elbow lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'ELBOW', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_5c20e0ebad7839c7106d0809da25a8fd = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_5c20e0ebad7839c7106d0809da25a8fd,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_5c20e0ebad7839c7106d0809da25a8fd,1);

--  Row 70 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Forearm AP', 'arm forearm ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'FOREARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_0a30c58e251fdf01c903f36df048270d = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_0a30c58e251fdf01c903f36df048270d,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_0a30c58e251fdf01c903f36df048270d,1);

--  Row 71 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Forearm Lateral', 'arm forearm lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'FOREARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_98435a6b5351d0d5bc95459604325106 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_98435a6b5351d0d5bc95459604325106,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_98435a6b5351d0d5bc95459604325106,1);

--  Row 72 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Wrist PA', 'arm wrist pa', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'WRIST', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'PA', 1);
set @test_4c9fa2136b7dd83b0710be140f021491 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_4c9fa2136b7dd83b0710be140f021491,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_4c9fa2136b7dd83b0710be140f021491,1);

--  Row 73 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Wrist AP', 'arm wrist ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'WRIST', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_a516d9dd12a821f3d112126cc570fa1d = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_a516d9dd12a821f3d112126cc570fa1d,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_a516d9dd12a821f3d112126cc570fa1d,1);

--  Row 74 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Wrist Lateral', 'arm wrist lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'WRIST', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_53c4296274cc9e1e7f4302a91881b9e9 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_53c4296274cc9e1e7f4302a91881b9e9,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_53c4296274cc9e1e7f4302a91881b9e9,1);

--  Row 75 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Scaphoid', 'arm scaphoid', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SCAPHOID', 1);
set @test_c33759c6ed27b97ddc566b3bf4608a89 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_c33759c6ed27b97ddc566b3bf4608a89,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_c33759c6ed27b97ddc566b3bf4608a89,1);

--  Row 76 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Hand AP', 'arm hand ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'HAND', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_41d9c983b9d89576fed87913fd1d49b6 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_41d9c983b9d89576fed87913fd1d49b6,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_41d9c983b9d89576fed87913fd1d49b6,1);

--  Row 77 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Hand oblique', 'arm hand oblique', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'HAND', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'OBLIQUE', 1);
set @test_80fb503ad2f764acea51da49d46a8fe5 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_80fb503ad2f764acea51da49d46a8fe5,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_80fb503ad2f764acea51da49d46a8fe5,1);

--  Row 78 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ARM Finger lateral', 'arm finger lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ARM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'FINGER', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_e053263654d0d99333a7644d1f8eadba = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_e053263654d0d99333a7644d1f8eadba,1);
call add_concept_set_members(@category_184e71c3fda19f0790fae7f71952de51,@test_e053263654d0d99333a7644d1f8eadba,1);

--  Row 79 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Pelvis', 'leg pelvis', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'PELVIS', 1);
set @test_091855012c44f1d3b0b7dc9c1caafbf6 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_091855012c44f1d3b0b7dc9c1caafbf6,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_091855012c44f1d3b0b7dc9c1caafbf6,1);

--  Row 80 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Hip joint AP', 'leg hip joint ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'HIP', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'JOINT', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_703e9ce16e199b0d0473fdd956702854 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_703e9ce16e199b0d0473fdd956702854,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_703e9ce16e199b0d0473fdd956702854,1);

--  Row 81 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Hip joint Lateral ', 'leg hip joint lateral ', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'HIP', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'JOINT', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_741dbf4a22b0ab110257ead3a1ef2488 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_741dbf4a22b0ab110257ead3a1ef2488,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_741dbf4a22b0ab110257ead3a1ef2488,1);

--  Row 82 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Femur AP', 'leg femur ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'FEMUR', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_d135574d4e2e42eb58fcb946915c5996 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_d135574d4e2e42eb58fcb946915c5996,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_d135574d4e2e42eb58fcb946915c5996,1);

--  Row 83 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Femur Lateral ', 'leg femur lateral ', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'FEMUR', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_ece1b9221d58269f27bca5f9e1b1fe38 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_ece1b9221d58269f27bca5f9e1b1fe38,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_ece1b9221d58269f27bca5f9e1b1fe38,1);

--  Row 84 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Knee AP', 'leg knee ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'KNEE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_eee609ea90bd1d75209cbae312a390c1 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_eee609ea90bd1d75209cbae312a390c1,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_eee609ea90bd1d75209cbae312a390c1,1);

--  Row 85 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Knee lateral', 'leg knee lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'KNEE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_157f6f0874b7d22ba5275f2e246a2bdc = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_157f6f0874b7d22ba5275f2e246a2bdc,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_157f6f0874b7d22ba5275f2e246a2bdc,1);

--  Row 86 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Lower leg including knee', 'leg lower leg including knee', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LOWER', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'INCLUDING', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'KNEE', 1);
set @test_4238818744cd16cb6a4b0b88481d0b8d = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_4238818744cd16cb6a4b0b88481d0b8d,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_4238818744cd16cb6a4b0b88481d0b8d,1);

--  Row 87 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Lower leg including ankle', 'leg lower leg including ankle', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LOWER', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'INCLUDING', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'ANKLE', 1);
set @test_5a4ed95f20acc8927dedcef62bf793e5 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_5a4ed95f20acc8927dedcef62bf793e5,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_5a4ed95f20acc8927dedcef62bf793e5,1);

--  Row 88 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Ankle joint', 'leg ankle joint', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'ANKLE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'JOINT', 1);
set @test_834fef793f46db4dee9e48beabd99a72 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_834fef793f46db4dee9e48beabd99a72,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_834fef793f46db4dee9e48beabd99a72,1);

--  Row 89 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Foot AP', 'leg foot ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'FOOT', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_fe13a72dfbd29b7167b4127efac4c273 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_fe13a72dfbd29b7167b4127efac4c273,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_fe13a72dfbd29b7167b4127efac4c273,1);

--  Row 90 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Foot oblique', 'leg foot oblique', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'FOOT', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'OBLIQUE', 1);
set @test_c160c7ef4e6f895e8cedb5297ca33690 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_c160c7ef4e6f895e8cedb5297ca33690,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_c160c7ef4e6f895e8cedb5297ca33690,1);

--  Row 91 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'LEG Foot lateral', 'leg foot lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'LEG', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'FOOT', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_00eebdcaf31adbcddd4dafb5d4e49b62 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_00eebdcaf31adbcddd4dafb5d4e49b62,1);
call add_concept_set_members(@category_4eeb220fb7213c3543a080735be8dbe3,@test_00eebdcaf31adbcddd4dafb5d4e49b62,1);

--  Row 92 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'CHEST PA ', 'chest pa ', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CHEST', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'PA', 1);
set @test_fbef28bdd4e475f159e36d77007c41bc = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_fbef28bdd4e475f159e36d77007c41bc,1);
call add_concept_set_members(@category_826b87e8826239260b38566579f735c3,@test_fbef28bdd4e475f159e36d77007c41bc,1);

--  Row 93 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'CHEST Lateral ', 'chest lateral ', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CHEST', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_711498eeb0a5212921e6df14c6126791 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_711498eeb0a5212921e6df14c6126791,1);
call add_concept_set_members(@category_826b87e8826239260b38566579f735c3,@test_711498eeb0a5212921e6df14c6126791,1);

--  Row 94 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'CHEST AP', 'chest ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CHEST', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_7bf726e0cc593e2ec80dfb6d3ea5288c = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_7bf726e0cc593e2ec80dfb6d3ea5288c,1);
call add_concept_set_members(@category_826b87e8826239260b38566579f735c3,@test_7bf726e0cc593e2ec80dfb6d3ea5288c,1);

--  Row 95 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'CHEST apical lordotic', 'chest apical lordotic', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CHEST', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'APICAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LORDOTIC', 1);
set @test_abc5bf5c1ae1dead5ca2c8fbe94666a6 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_abc5bf5c1ae1dead5ca2c8fbe94666a6,1);
call add_concept_set_members(@category_826b87e8826239260b38566579f735c3,@test_abc5bf5c1ae1dead5ca2c8fbe94666a6,1);

--  Row 96 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ABDOMEN AP Supine', 'abdomen ap supine', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ABDOMEN', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SUPINE', 1);
set @test_53555072598634688635f51db0be1ce9 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_53555072598634688635f51db0be1ce9,1);
call add_concept_set_members(@category_69cdbed97f594ce133240fedaf38b13d,@test_53555072598634688635f51db0be1ce9,1);

--  Row 97 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ABDOMEN PA/AP standing erect', 'abdomen pa/ap standing erect', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ABDOMEN', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'PA/AP', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'STANDING', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'ERECT', 1);
set @test_aa8d8d43ba1ae9b88c557c1e6b94fe52 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_aa8d8d43ba1ae9b88c557c1e6b94fe52,1);
call add_concept_set_members(@category_69cdbed97f594ce133240fedaf38b13d,@test_aa8d8d43ba1ae9b88c557c1e6b94fe52,1);

--  Row 98 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ABDOMEN lateral decubitus', 'abdomen lateral decubitus', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ABDOMEN', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'DECUBITUS', 1);
set @test_0d941d7dd615849e998abc88a7fbbc95 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_0d941d7dd615849e998abc88a7fbbc95,1);
call add_concept_set_members(@category_69cdbed97f594ce133240fedaf38b13d,@test_0d941d7dd615849e998abc88a7fbbc95,1);

--  Row 99 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ABDOMEN supine urography', 'abdomen supine urography', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ABDOMEN', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SUPINE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'UROGRAPHY', 1);
set @test_37b37b46f62e59d0a744ecd029c115ff = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_37b37b46f62e59d0a744ecd029c115ff,1);
call add_concept_set_members(@category_69cdbed97f594ce133240fedaf38b13d,@test_37b37b46f62e59d0a744ecd029c115ff,1);

--  Row 100 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'ABDOMEN urinary bladder', 'abdomen urinary bladder', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'ABDOMEN', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'URINARY', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'BLADDER', 1);
set @test_18cb99b9313cf1bbc514c154511495b0 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_18cb99b9313cf1bbc514c154511495b0,1);
call add_concept_set_members(@category_69cdbed97f594ce133240fedaf38b13d,@test_18cb99b9313cf1bbc514c154511495b0,1);

--  Row 101 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'HEAD Skull PA', 'head skull pa', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HEAD', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SKULL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'PA', 1);
set @test_159bd1487e1445034ea78833d93b8a58 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_159bd1487e1445034ea78833d93b8a58,1);
call add_concept_set_members(@category_87e43f25dacfe6514ec7454b3ca1b675,@test_159bd1487e1445034ea78833d93b8a58,1);

--  Row 102 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'HEAD Skull AP', 'head skull ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HEAD', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SKULL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_180fd4a9d3b19bebb70395c3a6b24fac = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_180fd4a9d3b19bebb70395c3a6b24fac,1);
call add_concept_set_members(@category_87e43f25dacfe6514ec7454b3ca1b675,@test_180fd4a9d3b19bebb70395c3a6b24fac,1);

--  Row 103 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'HEAD Skull semiaxial (Towne’s)', 'head skull semiaxial (towne’s)', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HEAD', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SKULL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SEMIAXIAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, '(TOWNE’S)', 1);
set @test_506453ef822a87fe0b5b9fffb630035d = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_506453ef822a87fe0b5b9fffb630035d,1);
call add_concept_set_members(@category_87e43f25dacfe6514ec7454b3ca1b675,@test_506453ef822a87fe0b5b9fffb630035d,1);

--  Row 104 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'HEAD Skull lateral', 'head skull lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HEAD', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SKULL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_0c81bde1da5af382a74d68d2d16b7acc = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_0c81bde1da5af382a74d68d2d16b7acc,1);
call add_concept_set_members(@category_87e43f25dacfe6514ec7454b3ca1b675,@test_0c81bde1da5af382a74d68d2d16b7acc,1);

--  Row 105 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'HEAD Sinus and face lateral', 'head sinus and face lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HEAD', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SINUS', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AND', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'FACE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_fd687f3b1ccfb83e07369e9a639390dc = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_fd687f3b1ccfb83e07369e9a639390dc,1);
call add_concept_set_members(@category_87e43f25dacfe6514ec7454b3ca1b675,@test_fd687f3b1ccfb83e07369e9a639390dc,1);

--  Row 106 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'HEAD Nose lateral', 'head nose lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HEAD', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'NOSE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_066ae304c28add9d1f489621e85a2a0b = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_066ae304c28add9d1f489621e85a2a0b,1);
call add_concept_set_members(@category_87e43f25dacfe6514ec7454b3ca1b675,@test_066ae304c28add9d1f489621e85a2a0b,1);

--  Row 107 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'HEAD Mandible AP', 'head mandible ap', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HEAD', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'MANDIBLE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP', 1);
set @test_a83c859571beccdaa009e5de222999be = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_a83c859571beccdaa009e5de222999be,1);
call add_concept_set_members(@category_87e43f25dacfe6514ec7454b3ca1b675,@test_a83c859571beccdaa009e5de222999be,1);

--  Row 108 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'HEAD Mandible PA', 'head mandible pa', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HEAD', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'MANDIBLE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'PA', 1);
set @test_a2fee39da4323f059b845bc4f2451fe4 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_a2fee39da4323f059b845bc4f2451fe4,1);
call add_concept_set_members(@category_87e43f25dacfe6514ec7454b3ca1b675,@test_a2fee39da4323f059b845bc4f2451fe4,1);

--  Row 109 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'HEAD Mandible oblique lateral', 'head mandible oblique lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'HEAD', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'MANDIBLE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'OBLIQUE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_e2c0a1ed87673f13ce81747cf97fda2b = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_e2c0a1ed87673f13ce81747cf97fda2b,1);
call add_concept_set_members(@category_87e43f25dacfe6514ec7454b3ca1b675,@test_e2c0a1ed87673f13ce81747cf97fda2b,1);

--  Row 110 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'SPINE Cervical AP/PA', 'spine cervical ap/pa', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPINE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'CERVICAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP/PA', 1);
set @test_f776f29155a5e3130b0a9955a8591d31 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_f776f29155a5e3130b0a9955a8591d31,1);
call add_concept_set_members(@category_f7ddf75687b851effa874c136a95708d,@test_f776f29155a5e3130b0a9955a8591d31,1);

--  Row 111 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'SPINE Cervical Lateral', 'spine cervical lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPINE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'CERVICAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_3c806b20fa26293e4ec6669b9572eae3 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_3c806b20fa26293e4ec6669b9572eae3,1);
call add_concept_set_members(@category_f7ddf75687b851effa874c136a95708d,@test_3c806b20fa26293e4ec6669b9572eae3,1);

--  Row 112 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'SPINE Thoracic AP/PA', 'spine thoracic ap/pa', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPINE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'THORACIC', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP/PA', 1);
set @test_2d628b03d8bf3ffadb786c75c386953e = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_2d628b03d8bf3ffadb786c75c386953e,1);
call add_concept_set_members(@category_f7ddf75687b851effa874c136a95708d,@test_2d628b03d8bf3ffadb786c75c386953e,1);

--  Row 113 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'SPINE Thoracic Lateral', 'spine thoracic lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPINE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'THORACIC', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_9cbfe50faf0f4ec91e87cd048410c935 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_9cbfe50faf0f4ec91e87cd048410c935,1);
call add_concept_set_members(@category_f7ddf75687b851effa874c136a95708d,@test_9cbfe50faf0f4ec91e87cd048410c935,1);

--  Row 114 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'SPINE Lumbo-sacral AP/PA', 'spine lumbo-sacral ap/pa', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPINE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LUMBO-SACRAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'AP/PA', 1);
set @test_6e4a9a68dd26cda8bb6143b423748aff = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_6e4a9a68dd26cda8bb6143b423748aff,1);
call add_concept_set_members(@category_f7ddf75687b851effa874c136a95708d,@test_6e4a9a68dd26cda8bb6143b423748aff,1);

--  Row 115 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'SPINE Lumbo-sacral Lateral', 'spine lumbo-sacral lateral', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPINE', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LUMBO-SACRAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'LATERAL', 1);
set @test_e40ead05c0045683360b545e428e1a93 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_e40ead05c0045683360b545e428e1a93,1);
call add_concept_set_members(@category_f7ddf75687b851effa874c136a95708d,@test_e40ead05c0045683360b545e428e1a93,1);

--  Row 116 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'Special X Rays', 'special x rays', 'N/A', 'ConvSet', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'SPECIAL', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'X', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'RAYS', 1);
set @category_5fd2bffe78a81971d512120ade7eda8b = @concept_id;
call add_concept_set_members(@other_investigations_categories_concept_id,@category_5fd2bffe78a81971d512120ade7eda8b,1);
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'BARIUM STUDY Barium swallow', 'barium study barium swallow', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'BARIUM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'STUDY', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'BARIUM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'SWALLOW', 1);
set @test_217640cc52d2132036926f20849a8f50 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_217640cc52d2132036926f20849a8f50,1);
call add_concept_set_members(@category_5fd2bffe78a81971d512120ade7eda8b,@test_217640cc52d2132036926f20849a8f50,1);

--  Row 117 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'BARIUM STUDY Barium meal', 'barium study barium meal', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'BARIUM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'STUDY', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'BARIUM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'MEAL', 1);
set @test_ea984cfaf68b7ff10c2ba6434ec95945 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_ea984cfaf68b7ff10c2ba6434ec95945,1);
call add_concept_set_members(@category_5fd2bffe78a81971d512120ade7eda8b,@test_ea984cfaf68b7ff10c2ba6434ec95945,1);

--  Row 118 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'BARIUM STUDY Barium Enema', 'barium study barium enema', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'BARIUM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'STUDY', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'BARIUM', 1);
call add_concept_word(@concept_id, @concept_name_short_id, 'ENEMA', 1);
set @test_de8d86efe2e917c8c54a2795ff121026 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_de8d86efe2e917c8c54a2795ff121026,1);
call add_concept_set_members(@category_5fd2bffe78a81971d512120ade7eda8b,@test_de8d86efe2e917c8c54a2795ff121026,1);

--  Row 119 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'RGU', 'rgu', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'RGU', 1);
set @test_561c6be79434bfe955e647231c0d1439 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_561c6be79434bfe955e647231c0d1439,1);
call add_concept_set_members(@category_5fd2bffe78a81971d512120ade7eda8b,@test_561c6be79434bfe955e647231c0d1439,1);

--  Row 120 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'KUB', 'kub', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'KUB', 1);
set @test_5319d4df2ecb439874f38936809c4679 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_5319d4df2ecb439874f38936809c4679,1);
call add_concept_set_members(@category_5fd2bffe78a81971d512120ade7eda8b,@test_5319d4df2ecb439874f38936809c4679,1);

--  Row 121 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'CT ', 'ct ', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'CT', 1);
set @test_37cad4d71aea3614f4f458182362673d = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_37cad4d71aea3614f4f458182362673d,1);
call add_concept_set_members(@category_dd9d5ba28690c78f7dac5a4aba986edb,@test_37cad4d71aea3614f4f458182362673d,1);

--  Row 122 
call add_concept(@concept_id, @concept_name_short_id, @concept_name_full_id, 'MRI', 'mri', 'Text', 'Test', true);
call add_concept_word(@concept_id, @concept_name_short_id, 'MRI', 1);
set @test_70ba83a096450918bf7b735462cc37d0 = @concept_id;
call add_concept_set_members(@investigation_0333e700220b8a5b1dace16b34380773,@test_70ba83a096450918bf7b735462cc37d0,1);
call add_concept_set_members(@category_dd9d5ba28690c78f7dac5a4aba986edb,@test_70ba83a096450918bf7b735462cc37d0,1);
